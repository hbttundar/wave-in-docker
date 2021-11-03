#!/bin/bash
set -e
if [ "$APP_ENV" == "local" ] ;then
    echo "starting optimizing ..."
    php artisan optimize
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    echo "optimizing finished. "
fi
