#!/bin/bash
set -e
# optimized and cache routes && config
echo "start optimizing laravel ..."
php artisan optimize
php artisan route:clear
php artisan config:clear
echo "laravel optimizing finished."

# shellcheck disable=SC1073
if [ ! -z "$WWWUSER" ]; then
  usermod -u $WWWUSER wave_cms
fi

if [ ! -d /.composer ]; then
  mkdir /.composer
fi

chmod -R ugo+rw /.composer

echo "start supervisord ..."
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
echo "supervisord started."
