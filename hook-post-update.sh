#!/bin/sh

HPU_DOMAIN=$1
HPU_GIT_DIR="$2/../"
HPU_GIT_BRANCH=main

echo -e "\e[1;36mdeploymy.site\e[0m 🚀 \e[34;4mhttps://$HPU_DOMAIN/\e[0m"
git --work-tree=$HPU_DOMAIN --git-dir=$HPU_GIT_DIR checkout -f -q $HPU_GIT_BRANCH 

cd "/var/www/$HPU_DOMAIN" 

[[ -e composer.json ]] && echo -e -n "Running composer... " && composer install -n -q && echo -e "\e[1;32mok\e[0m"

echo -e -n "Running migrations... "
echo -e "\e[2mno migrations\e[0m"
echo -e -n "Running config... "
echo -e -n "\e[1;31merror\e[0m"
echo -e " \e[2mmore info in \e[0m\e[34;4mhttps://deploymy.site/config-error\e[0m"
[[ -e .env.example ]] && cp -n .env.example .env
echo -e "\e[1;32mDone!\e[0m"
