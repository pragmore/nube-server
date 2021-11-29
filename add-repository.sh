#!/bin/bash
#
# Create new repository

NAME=$1
DOMAIN=$2

REPO_DIR="$HOME/git/$NAME"
POST_UPDATE_FILE="$REPO_DIR/hooks/post-update"

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
echo "hook-post-update.sh \"$DOMAIN\" \"$REPO_DIR\"" >> $POST_UPDATE_FILE
chmod a+x $POST_UPDATE_FILE
