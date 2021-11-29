#!/bin/bash
#
# Create new repository

NAME=$1
DOMAIN=${2:-$1}

REPO_DIR="$HOME/git/$NAME"
POST_UPDATE_FILE="$REPO_DIR/hooks/post-update"

NUBE_SLUG=$(echo $DOMAIN | sed 's/[-\.]/_/g')

readonly NUBE_DB_CONN="mysql"
readonly NUBE_DB_HOST="127.0.0.1"
readonly NUBE_DB_PORT="3306"
readonly NUBE_SECRETS_FILE="$HOME/secrets.gpg"

[ -f $NUBE_SECRETS_FILE ] && $(gpg  -q --decrypt $NUBE_SECRETS_FILE)

if [ ! -d "$REPO_DIR" ]; then
    echo "create repository folder"
    mkdir -p $REPO_DIR
    cd $REPO_DIR
    git init --bare
    echo "create post update hook"
else
    echo "update post update hook"
fi

echo '#!/bin/bash' > $POST_UPDATE_FILE
echo "# Generated on $(date)" >> $POST_UPDATE_FILE
echo "nube-hook-post-update \"$DOMAIN\" \"$REPO_DIR\"" >> $POST_UPDATE_FILE
chmod a+x $POST_UPDATE_FILE

echo "Copy this in mysql"
echo ""
echo "-----"
echo ""
echo "CREATE DATABASE IF NOT EXISTS $NUBE_SLUG;" 
echo "GRANT ALL PRIVILEGES ON $NUBE_SLUG . * TO '$NUBE_DB_USER'@'$NUBE_DB_HOST';"
echo "FLUSH PRIVILEGES;"
echo ""
echo "-----"
echo ""
