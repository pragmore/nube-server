#!/bin/bash
NAME=$1
DOMAIN=$2

REPO_DIR="/repository/$NAME.git"
POST_UPDATE_FILE="$REPO_DIR/hooks/post-update"

if [ ! -d "$REPO_DIR" ]; then
    echo "create repository folder"
    mkdir $REPO_DIR
    cd $REPO_DIR
    git init --bare
    echo "create post update hook"
else
    echo "update post update hook"
fi


echo "#!/bin/sh" > $POST_UPDATE_FILE
echo "hook-post-update \"$DOMAIN\" `pwd`" > $POST_UPDATE_FILE
