#!/bin/bash
DOMAIN=$1
WEB_PATH="$HOME/www/$DOMAIN"
PUBLIC_PATH="$WEB_PATH/public"
echo "creating folder"
mkdir -p $PUBLIC_PATH
ln -s $WEB_PATH "/var/www/$DOMAIN"
echo "creating home page"
echo "<html><body><?= \"$DOMAIN \" ?></body></html>" > "$PUBLIC_PATH/index.php"
/home/ec2-user/.acme.sh/acme.sh --issue -d $DOMAIN -w "$PUBLIC_PATH --stateless"
