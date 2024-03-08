#!/bin/bash
#
# Set up a new domain app

DOMAIN=$1
WEB_PATH="$HOME/www/$DOMAIN"
PUBLIC_PATH="$WEB_PATH/public"
echo "creating folder"
mkdir -p $PUBLIC_PATH
chgrp -R www-data $PUBLIC_PATH
ln -s $WEB_PATH "/var/www/$DOMAIN"
echo "creating home page"
echo "<html><body><?= \"$DOMAIN \" ?></body></html>" > "$PUBLIC_PATH/index.php"
/home/ubuntu/.acme.sh/acme.sh --issue -d $DOMAIN -w "$PUBLIC_PATH" --stateless
