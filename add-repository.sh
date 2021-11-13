#!/bin/bash
NAME=$1
DOMAIN=$2
REPLACE_DOMAIN="REPLACE_DOMAIN"
REPLACE_NAME="REPLACE_NAME"

REPO_DIR="/repository/$NAME.git"
POST_UPDATE_FILE="$REPO_DIR/hooks/post-update"

echo "create repository folder"
mkdir $REPO_DIR
cd $REPO_DIR
git init --bare
echo "create post update hook"
cp /repository/post-update $POST_UPDATE_FILE
sudo sed -i "s/$REPLACE_DOMAIN/$DOMAIN/g" $POST_UPDATE_FILE 
sudo sed -i "s/$REPLACE_NAME/$NAME/g" $POST_UPDATE_FILE 
