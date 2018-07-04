#!/bin/sh
set -e
mkdir -p /home/worker/data/php/logs/xdebug
# start nginx,php-fpm
setuser worker /home/worker/php/sbin/php-fpm -c /home/worker/php/etc/php-fpm.ini
/home/worker/nginx/sbin/nginx

# start socket and task services if you have
#php /home/worker/data/www/gamer-socket/server_dev.php
#php /home/worker/data/www/gamer-worker/server_dev.php