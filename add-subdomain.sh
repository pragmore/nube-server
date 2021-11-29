#!/bin/bash
#
# Set up a new sub domain app

NAME=$1
DOMAIN="$NAME.nube.pragmore.com"
WEB_PATH="$HOME/www/$DOMAIN"
PUBLIC_PATH="$WEB_PATH/public"
echo "creating folder"
mkdir -p $PUBLIC_PATH
ln -s $WEB_PATH "/var/www/$DOMAIN"
echo "creating home page"
echo "<html><body><?= \"$NAME \" ?></body></html>" > "$PUBLIC_PATH/index.php"
