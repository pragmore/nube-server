#!/bin/bash

HPU_DOMAIN="$1"
HPU_GIT_DIR="$2"
HPU_GIT_BRANCH=main

HPU_PATH="/var/www/$HPU_DOMAIN"
HPU_SLUG=$(echo $HPU_DOMAIN | sed 's/[-\.]/_/g')
HPU_URL="https://$HPU_DOMAIN"

HPU_OK_MESSAGE="\e[32;1m ok\e[0m"
HPU_ERROR_MESSAGE="\e[31;1m error\e[0m"

HPU_UPLOAD_MESSAGE="Subir a \e[34m$HPU_DOMAIN\e[0m"
HPU_COPY_CONFIG_MESSAGE="Copiar configuracion inicial..."
HPU_RUNNING_COMPOSER_MESSAGE="Instalando composer..." 
HPU_FRAMEWORK_MESSAGE="Framework encontrado:" 
HPU_MIGRATIONS_MESSAGES="Corriendo migraciones..." 
HPU_CACHE_CONFIG_MESSAGE="Cacheando configuracion..."
HPU_CACHE_ROUTES_MESSAGE="Cacheando rutas..."
HPU_CACHE_VIEWS_MESSAGE="Cacheando vistas..."
HPU_GENERATE_KEYS_MESSAGE="Generando claves..."
HPU_DONE_MESSAGE="Listo"
HPU_PROCESS_ERROR_MESSAGE="$HPU_ERROR_MESSAGE Ha ocurrido un error, por favor reportar a nube@pragmore.com con el siguiente mensaje: "

HPU_DB_CONN="mysql"
HPU_DB_HOST="127.0.0.1"
HPU_DB_PORT="3306"
HPU_DB_USER="root"
HPU_DB_PASS="wGXFT4x3hyeAQtC"

_hpu_welcome() {
    echo -e "\e[36;1mnube.pragmore.com\e[0m 🚀 $HPU_UPLOAD_MESSAGE"
}

_hpu_done() {
    echo -e "\e[1;32m$HPU_DONE_MESSAGE\e[0m → 🔗 \e[34;4m$HPU_URL\e[0m"
}

_hpu_cd_web_path() {
    [ ! -d $HPU_PATH ] && echo -e "$HPU_PROCESS_ERROR_MESSAGE No se encuentra $HPU_PATH" && exit
    cd $HPU_PATH
}

_hpu_deploy_files() {
    git --work-tree=$HPU_PATH --git-dir=$HPU_GIT_DIR checkout -f -q $HPU_GIT_BRANCH 
}

_hpu_create_db() {
    echo "CREATE DATABASE IF NOT EXISTS $HPU_SLUG" | \
        mysql -u$HPU_DB_USER -p$HPU_DB_PASS --host=$HPU_DB_HOST --port=$HPU_DB_PORT 2> /dev/null
}

_hpu_dotenv() {
    [ ! -f .env ] && [ -f .env.example ] && echo -e -n $HPU_COPY_CONFIG_MESSAGE \
        && (cp .env.example .env && echo -e $HPU_OK_MESSAGE || echo -e $HPU_ERROR_MESSAGE)
}

_hpu_composer_install() {
    [ -f composer.json ] && echo -e -n $HPU_RUNNING_COMPOSER_MESSAGE \
        && (composer install --optimize-autoloader --no-dev -n -q && echo -e $HPU_OK_MESSAGE  || echo -e $HPU_ERROR_MESSAGE)
}

_hpu_framework_found() {
    echo -e "$HPU_FRAMEWORK_MESSAGE \e[1m$1\e[0m"
}

_hpu_laravel_dotenv() {
    sed -i "s#APP_URL=.*#APP_URL=$HPU_URL#g" .env

    sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=$HPU_DB_CONN/g" .env
    sed -i "s/DB_HOST=.*/DB_HOST=$HPU_DB_HOST/g" .env
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=$HPU_SLUG/g" .env
    sed -i "s/DB_PORT=.*/DB_PORT=$HPU_DB_PORT/g" .env
    sed -i "s/DB_USERNAME=.*/DB_USERNAME=$HPU_DB_USER/g" .env
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$HPU_DB_PASS/g" .env

    [ ! $(grep APP_KEY=base .env) ] && echo -e -n $HPU_GENERATE_KEYS_MESSAGE && php artisan key:generate
}

_hpu_laravel_fix_max_key_bug() {
    grep Schema::defaultStringLength app/Providers/AppServiceProvider.php || sed -i '/boot()/{N;N;
        a \ \ \ \ \ \ \ \ \\Illuminate\\Support\\Facades\\Schema::defaultStringLength(191); /* Max key error https://github.com/laravel/framework/issues/24711 */
    }' app/Providers/AppServiceProvider.php 
}

_hpu_laravel_deploy() {
    echo -e -n $HPU_CACHE_CONFIG_MESSAGE && php artisan config:cache -q && echo -e $HPU_OK_MESSAGE  || echo -e $HPU_ERROR_MESSAGE
    echo -e -n $HPU_CACHE_ROUTES_MESSAGE && php artisan route:cache -q && echo -e $HPU_OK_MESSAGE  || echo -e $HPU_ERROR_MESSAGE
    echo -e -n $HPU_CACHE_VIEWS_MESSAGE && php artisan view:cache -q && echo -e $HPU_OK_MESSAGE  || echo -e $HPU_ERROR_MESSAGE
}

_hpu_laravel_migrate() {
    echo -e -n $HPU_MIGRATIONS_MESSAGES && php artisan migrate --force
}

_hpu_welcome
_hpu_cd_web_path
_hpu_deploy_files
_hpu_create_db
_hpu_dotenv
_hpu_composer_install

# Laravel
if [ -f artisan ]; then
    _hpu_framework_found "Laravel"
    _hpu_laravel_dotenv
    _hpu_laravel_fix_max_key_bug
    _hpu_laravel_deploy
    _hpu_laravel_migrate
fi

_hpu_done
