#!/bin/sh

HPU_DOMAIN="$1"
HPU_GIT_DIR="$2"
HPU_GIT_BRANCH=main
HPU_PATH="/var/www/$HPU_DOMAIN"

HPU_OK_MESSAGE="\e[1;32m ok\e[0m"
HPU_ERROR_MESSAGE="\e[1;31m error\e[0m"

HPU_UPLOAD_MESSAGE="Subir a \e[34m$HPU_DOMAIN\e[0m"
HPU_COPY_CONFIG_MESSAGE="Copiar configuracion inicial..."
HPU_RUNNING_COMPOSER_MESSAGE="Instalando composer..." 
HPU_FRAMEWORK_MESSAGE="Framework encontrado:" 
HPU_MIGRATIONS_MESSAGES="Corriendo migraciones..." 
HPU_CACHE_CONFIG_MESSAGE="Cacheando configuracion..."
HPU_CACHE_ROUTES_MESSAGE="Cacheando rutas..."
HPU_CACHE_VIEWS_MESSAGE="Cacheando vistas..."
HPU_DONE_MESSAGE="Listo"

echo -e "\e[1m\e[1;36mnube.pragmore.com\e[0m\e[0m 🚀 $HPU_UPLOAD_MESSAGE"

git --work-tree=$HPU_PATH --git-dir=$HPU_GIT_DIR checkout -f -q $HPU_GIT_BRANCH 

cd $HPU_PATH

# Common .env configs
[ ! -f .env ] && [ -f .env.example ] && echo -e -n $HPU_COPY_CONFIG_MESSAGE \
    && (cp .env.example .env && echo -e $HPU_OK_MESSAGE || echo -e $HPU_ERROR_MESSAGE)

# Common composer install
[ -f composer.json ] && echo -e -n $HPU_RUNNING_COMPOSER_MESSAGE \
    && (composer install --optimize-autoloader --no-dev -n -q && echo -e $HPU_OK_MESSAGE  || echo -e $HPU_ERROR_MESSAGE)

# Laravel
if [ -f artisan ]; then 

    echo -e "$HPU_FRAMEWORK_MESSAGE \e[1mLaravel\e[0m"

    echo -e -n $HPU_CACHE_CONFIG_MESSAGE && php artisan config:cache -q && echo -e $HPU_OK_MESSAGE  || echo -e $HPU_ERROR_MESSAGE
    echo -e -n $HPU_CACHE_ROUTES_MESSAGE && php artisan route:cache -q && echo -e $HPU_OK_MESSAGE  || echo -e $HPU_ERROR_MESSAGE
    echo -e -n $HPU_CACHE_VIEWS_MESSAGE && php artisan view:cache -q && echo -e $HPU_OK_MESSAGE  || echo -e $HPU_ERROR_MESSAGE
    echo -e -n $HPU_MIGRATIONS_MESSAGES && php artisan migrate --force

fi

echo -e "\e[1;32m$HPU_DONE_MESSAGE\e[0m → 🔗 \e[34;4mhttps://$HPU_DOMAIN/\e[0m"
