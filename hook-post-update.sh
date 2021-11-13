#!/bin/sh

HPU_DOMAIN="$1"
HPU_GIT_DIR="$2"
HPU_GIT_BRANCH=main
HPU_PATH="/var/www/$HPU_DOMAIN"

HPU_OK_MESSAGE="\e[1;32mok\e[0m"
HPU_ERROR_MESSAGE="\e[1;31merror\e[0m"

echo -e "\e[1;36mdeploymy.site\e[0m 🚀"
git --work-tree=$HPU_PATH --git-dir=$HPU_GIT_DIR checkout -f -q $HPU_GIT_BRANCH 

cd $HPU_PATH

[ ! -f .env ] && [ -f .env.example ] && echo -e -n "Copy default config... " && cp .env.example .env && echo -e $HPU_OK_MESSAGE

[[ -e composer.json ]] && echo -e -n "Running composer... " && composer install -n -q && echo -e $HPU_OK_MESSAGE 

echo -e -n "Running migrations... "
echo -e "\e[2mno migrations\e[0m"

echo -e "\e[1;32mDone!\e[0m check 🔗 \e[34;4mhttps://$HPU_DOMAIN/\e[0m"
