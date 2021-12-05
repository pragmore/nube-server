#!/bin/bash
#
# Deploy app 

readonly NUBE_REFS="$1"
readonly NUBE_DOMAIN="$2"
readonly NUBE_GIT_DIR="$3"
readonly NUBE_SECRETS_FILE="$HOME/secrets.gpg"

readonly NUBE_PATH="/var/www/$NUBE_DOMAIN"
readonly NUBE_SLUG=$(echo $NUBE_DOMAIN | sed 's/[-\.]/_/g')
readonly NUBE_URL="https://$NUBE_DOMAIN"

readonly NUBE_OK_MESSAGE="\e[32;1m ok\e[0m"
readonly NUBE_ERROR_MESSAGE="\e[31;1m error\e[0m"

readonly NUBE_UPLOAD_MESSAGE="Haciendo el deploy a \e[34m$NUBE_DOMAIN\e[0m"
readonly NUBE_COPY_CONFIG_MESSAGE="Copiar configuracion inicial..."
readonly NUBE_RUNNING_COMPOSER_MESSAGE="Instalando composer..." 
readonly NUBE_FRAMEWORK_MESSAGE="Framework encontrado:" 
readonly NUBE_MIGRATIONS_MESSAGES="Corriendo migraciones..." 
readonly NUBE_CACHE_CONFIG_MESSAGE="Cacheando configuracion..."
readonly NUBE_CACHE_ROUTES_MESSAGE="Cacheando rutas..."
readonly NUBE_CACHE_VIEWS_MESSAGE="Cacheando vistas..."
readonly NUBE_GENERATE_KEYS_MESSAGE="Generando claves..."
readonly NUBE_DONE_MESSAGE="Listo"
readonly NUBE_PROCESS_ERROR_MESSAGE="$NUBE_ERROR_MESSAGE Ha ocurrido un error.
Por favor reportar a nube@pragmore.com con el siguiente mensaje: "

readonly NUBE_DB_CONN="mysql"
readonly NUBE_DB_HOST="127.0.0.1"
readonly NUBE_DB_PORT="3306"
readonly NUBE_DB_NAME=$NUBE_SLUG

# Export user secrets
[ -f $NUBE_SECRETS_FILE ] && $(gpg  -q --decrypt $NUBE_SECRETS_FILE)

welcome() {
  echo -e "☁️  \e[35;1mNube\e[0m, by Pragmore - \e[34;4mhttps://nube.pragmore.com\e[0m 🚀"
  echo -e "$NUBE_UPLOAD_MESSAGE"
}

finish() {
  echo -e "\e[1;32m$NUBE_DONE_MESSAGE\e[0m → 🔗 \e[34;4m$NUBE_URL\e[0m"
  echo -e "Si necesitas ayuda puedes ir a \e[34;4mhttps://nube.pragmore.com/ayuda\e[0m"
}

cd_web_path() {
  [ ! -d $NUBE_PATH ] \
    && echo -e "$NUBE_PROCESS_ERROR_MESSAGE No se encuentra $NUBE_PATH" \
    && exit
  cd $NUBE_PATH
}

deploy_files() {
  git --work-tree=$NUBE_PATH --git-dir=$NUBE_GIT_DIR checkout -f -q $NUBE_REFS
}

dotenv() {
  [ ! -f .env ] && [ -f .env.example ] && echo -e -n $NUBE_COPY_CONFIG_MESSAGE \
    && (cp .env.example .env && echo -e $NUBE_OK_MESSAGE || echo -e $NUBE_ERROR_MESSAGE)
  [ -f .env ] && sed -i "s@#NUBE_ROOT#@$NUBE_PATH@g" .env
  [ -f .env ] && sed -i "s@#NUBE_URL#@$NUBE_URL@g" .env
  [ -f .env ] && sed -i "s/#NUBE_DB_CONN#/$NUBE_DB_CONN/g" .env
  [ -f .env ] && sed -i "s/#NUBE_DB_HOST#/$NUBE_DB_HOST/g" .env
  [ -f .env ] && sed -i "s/#NUBE_DB_PORT#/$NUBE_DB_PORT/g" .env
  [ -f .env ] && sed -i "s/#NUBE_DB_NAME#/$NUBE_DB_NAME/g" .env
  [ -f .env ] && sed -i "s/#NUBE_DB_USER#/$NUBE_DB_USER/g" .env
  [ -f .env ] && sed -i "s/#NUBE_DB_PASS#/$NUBE_DB_PASS/g" .env
}

composer_install() {
  [ -f composer.json ] && echo -e -n $NUBE_RUNNING_COMPOSER_MESSAGE \
    && (composer install --optimize-autoloader --no-dev -n -q \
        && echo -e $NUBE_OK_MESSAGE  || echo -e $NUBE_ERROR_MESSAGE)
}

framework_found() {
  echo -e "$NUBE_FRAMEWORK_MESSAGE \e[1m$1\e[0m"
}

laravel_dotenv() {
  sed -i "s#APP_URL=.*#APP_URL=$NUBE_URL#g" .env

  sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=$NUBE_DB_CONN/g" .env
  sed -i "s/DB_HOST=.*/DB_HOST=$NUBE_DB_HOST/g" .env
  sed -i "s/DB_DATABASE=.*/DB_DATABASE=$NUBE_DB_NAME/g" .env
  sed -i "s/DB_PORT=.*/DB_PORT=$NUBE_DB_PORT/g" .env
  sed -i "s/DB_USERNAME=.*/DB_USERNAME=$NUBE_DB_USER/g" .env
  sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$NUBE_DB_PASS/g" .env

  [ ! $(grep APP_KEY=base .env) ] && echo -e -n $NUBE_GENERATE_KEYS_MESSAGE \
    && php artisan key:generate
}

laravel_fix_max_key_bug() {
  local provider_file="app/Providers/AppServiceProvider.php" 
  grep Schema::defaultStringLength $provider_file || sed -i '/boot()/{N;N;
    a \ \ \ \ \ \ \ \ \\Illuminate\\Support\\Facades\\Schema::defaultStringLength(191); /* Max key error https://github.com/laravel/framework/issues/24711 */
  }' $provider_file 
}

laravel_deploy() {
  echo -e -n $NUBE_CACHE_CONFIG_MESSAGE && php artisan config:cache -q \
    && echo -e $NUBE_OK_MESSAGE  || echo -e $NUBE_ERROR_MESSAGE
  echo -e -n $NUBE_CACHE_ROUTES_MESSAGE && php artisan route:cache -q \
    && echo -e $NUBE_OK_MESSAGE  || echo -e $NUBE_ERROR_MESSAGE
  echo -e -n $NUBE_CACHE_VIEWS_MESSAGE && php artisan view:cache -q \
    && echo -e $NUBE_OK_MESSAGE  || echo -e $NUBE_ERROR_MESSAGE
}

laravel_migrate() {
  echo -e -n $NUBE_MIGRATIONS_MESSAGES && php artisan migrate --force
}

welcome
cd_web_path
deploy_files
dotenv
composer_install

# Laravel
if [ -f artisan ]; then
  framework_found "Laravel"
  laravel_dotenv
  laravel_fix_max_key_bug
  laravel_deploy
  laravel_migrate
fi

finish
