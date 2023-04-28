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
readonly NUBE_CURRENT_PATH="$HOME/www/$NUBE_DOMAIN"
readonly NUBE_PREV_PATH="$HOME/www/$NUBE_DOMAIN-prev"
readonly NUBE_DEPLOY_PATH="$HOME/www/$NUBE_DOMAIN-deploy"

readonly NUBE_OK_MESSAGE="\e[32;1m ok\e[0m"
readonly NUBE_ERROR_MESSAGE="\e[31;1m error\e[0m"
readonly NUBE_DEPLOY_ERROR_MESSAGE="\e[31;1m Ha ocurrido un error, se mantiene la versión anterior\e[0m"
readonly NUBE_DEPLOY_ERROR="$NUBE_DEPLOY_PATH/.nube_deploy_error"

readonly NUBE_START_MESSAGE="☁️  \e[35;1mNube\e[0m, by Pragmore - \e[34;4mhttps://nube.pragmore.com\e[0m 🚀"
readonly NUBE_UPLOAD_MESSAGE="Haciendo el deploy a \e[34m$NUBE_DOMAIN\e[0m"
readonly NUBE_COPY_CONFIG_MESSAGE="Copiar configuracion inicial..."
readonly NUBE_RUNNING_COMPOSER_MESSAGE="Instalando composer..." 
readonly NUBE_RUNNING_NPM_MESSAGE="Instalando npm..."
readonly NUBE_RESTARTING_PM2_MESSAGE="Reiniciando servidor de NodeJS..."
readonly NUBE_FRAMEWORK_MESSAGE="Framework encontrado:" 
readonly NUBE_MIGRATIONS_MESSAGES="Corriendo migraciones..." 
readonly NUBE_CACHE_CONFIG_MESSAGE="Cacheando configuracion..."
readonly NUBE_CACHE_ROUTES_MESSAGE="Cacheando rutas..."
readonly NUBE_CACHE_VIEWS_MESSAGE="Cacheando vistas..."
readonly NUBE_GENERATE_KEYS_MESSAGE="Generando claves..."
readonly NUBE_DONE_MESSAGE="Listo"
readonly NUBE_PROCESS_ERROR_MESSAGE="$NUBE_ERROR_MESSAGE Ha ocurrido un error.
Por favor reportar a nube@pragmore.com con el siguiente mensaje: "
readonly NUBE_HELP_MESSAGE="Si necesitas ayuda puedes ir a \e[34;4mhttps://nube.pragmore.com/ayuda\e[0m"

readonly NUBE_DB_CONN="mysql"
readonly NUBE_DB_HOST="127.0.0.1"
readonly NUBE_DB_PORT="3306"
readonly NUBE_DB_NAME=$NUBE_SLUG

# Export user secrets
[ -f $NUBE_SECRETS_FILE ] && $(gpg  -q --decrypt $NUBE_SECRETS_FILE)

nube_error() {
  touch "$NUBE_DEPLOY_ERROR"
  echo -e $NUBE_ERROR_MESSAGE
}

nube_start() {
  rm -rf "$NUBE_DEPLOY_PATH"
  echo -e "$NUBE_START_MESSAGE"
  echo -e "$NUBE_UPLOAD_MESSAGE"
}

help_message() {
  echo -e 
}

finish() {
  test -f "$NUBE_DEPLOY_ERROR" && echo -e "$NUBE_DEPLOY_ERROR_MESSAGE" && echo -e $NUBE_HELP_MESSAGE && exit
  rm -rf "$NUBE_PREV_PATH"
  mv "$NUBE_CURRENT_PATH" "$NUBE_PREV_PATH"
  mv "$NUBE_DEPLOY_PATH" "$NUBE_CURRENT_PATH"
  echo -e "\e[1;32m$NUBE_DONE_MESSAGE\e[0m → 🔗 \e[34;4m$NUBE_URL\e[0m"
}

cd_web_path() {
  mkdir -p $NUBE_DEPLOY_PATH
  [ ! -d $NUBE_PATH ] \
    && echo -e "$NUBE_PROCESS_ERROR_MESSAGE No se encuentra $NUBE_PATH" \
    && exit
  cd $NUBE_DEPLOY_PATH
}

deploy_files() {
  git --work-tree=$NUBE_DEPLOY_PATH --git-dir=$NUBE_GIT_DIR checkout -f -q $NUBE_REFS
}

dotenv() {
  # Try to copy current .env
  cp "$NUBE_PATH/.env" "$NUBE_DEPLOY_PATH/.env" 2>/dev/null
  # Use .env vars with a note with ref
  NUBE_REF_ENV=$(git --git-dir=$NUBE_GIT_DIR notes --ref=env list | tail -n1 | awk  '{ print $2 }')
  [ ! -z "$NUBE_REF_ENV" ] && git --git-dir=$NUBE_GIT_DIR notes --ref=env show $NUBE_REF_ENV > .env

  [ ! -f .env ] && [ -f .env.dist ] && echo -e -n $NUBE_COPY_CONFIG_MESSAGE \
    && (cp .env.dist .env && echo -e $NUBE_OK_MESSAGE || nube_error)
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
  [ -f composer.json ] && echo -e $NUBE_RUNNING_COMPOSER_MESSAGE \
    && (composer install --optimize-autoloader --no-dev -n -q \
        && echo -e $NUBE_OK_MESSAGE  || nube_error)
}

npm_install() {
  [ -f package.json ] && echo -e $NUBE_RUNNING_NPM_MESSAGE \
    && (NODE_OPTIONS=--max-old-space-size=950 npm ci --omit=dev \
        && echo -e $NUBE_OK_MESSAGE  || nube_error)
}

pm2_restart() {
  [ -f package.json ] && (pm2 ls | grep  $NUBE_DOMAIN \
        && (echo -e $NUBE_RESTARTING_PM2_MESSAGE \
          && pm2 restart $NUBE_DOMAIN \
          && echo -e $NUBE_OK_MESSAGE  || nube_error))
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

  [ ! $(grep --silent APP_KEY=base .env) ] && echo -e -n $NUBE_GENERATE_KEYS_MESSAGE \
    && php artisan key:generate --force -q -n \
    && echo -e $NUBE_OK_MESSAGE  || nube_error
}

laravel_write_permissions() {
  chmod -R a+w storage/
}

laravel_fix_max_key_bug() {
  local provider_file="app/Providers/AppServiceProvider.php" 
  grep --silent Schema::defaultStringLength $provider_file || sed -i '/boot()/{N;N;
    a \ \ \ \ \ \ \ \ \\Illuminate\\Support\\Facades\\Schema::defaultStringLength(191); /* Max key error https://github.com/laravel/framework/issues/24711 */
  }' $provider_file 
}

laravel_deploy() {
  echo -e -n $NUBE_CACHE_CONFIG_MESSAGE && php artisan config:cache -q \
    && echo -e $NUBE_OK_MESSAGE  || nube_error
  echo -e -n $NUBE_CACHE_ROUTES_MESSAGE && php artisan route:cache -q \
    && echo -e $NUBE_OK_MESSAGE  || nube_error
  echo -e -n $NUBE_CACHE_VIEWS_MESSAGE && php artisan view:cache -q \
    && echo -e $NUBE_OK_MESSAGE  || nube_error
}

laravel_migrate() {
  echo -e $NUBE_MIGRATIONS_MESSAGES && php artisan migrate --force
}

nube_start
cd_web_path
deploy_files
dotenv
npm_install
pm2_restart
composer_install

# Laravel
if [ -f artisan ]; then
  framework_found "Laravel"
  laravel_dotenv
  laravel_write_permissions
  laravel_fix_max_key_bug
  laravel_deploy
  laravel_migrate
fi

finish
