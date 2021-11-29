#!/bin/bash
#
# Creates a new user 

NEW_USER=$1
NEW_USER_MAIL=$2
NEW_USER_PUBKEY=$3

NEW_USER_HOME="/home/$NEW_USER"
DB_USER="${NEW_USER}_$(php -r "echo substr(md5(time()), 0, 16);")"
DB_PASS=$(openssl rand -base64 32)

useradd --shell $(command -v git-shell) --create-home $NEW_USER 

# Create db user
echo "create user '$DB_USER'@'127.0.0.1' IDENTIFIED BY '$DB_PASS';" | mysql 

cd "/home/$NEW_USER"

mkdir -p .ssh
echo $NEW_USER_PUBKEY > ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

# Create secret
touch secrets 
echo "export NUBE_DB_USER=$DB_USER" >> secrets 
echo "export NUBE_DB_PASS=$DB_PASS" >> secrets

runuser -u $NEW_USER -- gpg --batch --passphrase '' --quick-gen-key $NEW_USER_MAIL default default
runuser -u $NEW_USER -- ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
runuser -u $NEW_USER -- gpg -e -r $NEW_USER_MAIL secrets

rm secrets

chown -R $NEW_USER:$NEW_USER $USER_HOME
