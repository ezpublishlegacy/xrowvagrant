#!/bin/sh

sudo rm -Rf * .gitignore .travis.yml
composer -vvv create-project symfony/framework-standard-edition . 2.5.* --prefer-dist --no-interaction

cat <<EOL > app/config/parameters.yml
# This file is auto-generated during the composer install
parameters:
    database_driver: pdo_mysql
    database_host: 127.0.0.1
    database_port: null
    database_name: symfony
    database_user: root
    database_password: null
    mailer_transport: smtp
    mailer_host: 127.0.0.1
    mailer_user: null
    mailer_password: null
    locale: en
    secret: c60211546d9737d16d4a34e90fb9f7b1d69bacba
    debug_toolbar: true,
    debug_redirects: false,
    use_assetic_controller: true,
    database_path: null
EOL

cp app/config/parameters.yml app/config/parameters.yml.dist
mv web/config.php web/config.php.dist

composer -vvv install --no-interaction
composer -vvv update --no-interaction
sed -i "s/\/\/umask(/umask(/g" app/console
sed -i "s/\/\/umask(/umask(/g" web/app_dev.php
sed -i "s/\/\/umask(/umask(/g" web/app.php

find app/{cache,logs,config} -type d | sudo xargs chmod -R 777
find app/{cache,logs,config} -type f | sudo xargs chmod -R 666