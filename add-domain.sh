#!/bin/bash
DOMAIN=$1
REPLACE_DOMAIN="REPLACE_DOMAIN"
echo "disabling domain redirect"
sudo sed -i "s/$REPLACE_DOMAIN/$DOMAIN/g" /etc/nginx/conf.d/add-domain.conf
sudo systemctl reload nginx.service
echo "creating folder"
mkdir -p /var/www/$DOMAIN/public
echo "creating home page"
echo "<html><body><?= echo \"$DOMAIN \" ?></body></html>" > /var/www/$DOMAIN/public/index.php
/home/ec2-user/.acme.sh/acme.sh --issue -d $DOMAIN -w /var/www/$DOMAIN/public/
echo "reenabling domaing redirect"
sudo sed -i "s/$DOMAIN/$REPLACE_DOMAIN/g" /etc/nginx/conf.d/add-domain.conf
sudo systemctl reload nginx.service

