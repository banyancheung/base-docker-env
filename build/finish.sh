#!/bin/sh
set -e

### startup scripts
ln -sf /usr/share/zoneinfo/Asia/Chongqing /etc/localtime

mkdir -p /home/worker/data/php/run
mkdir -p /home/worker/data/php/logs
mkdir -p /home/worker/data/nginx/logs
mkdir -p /home/worker/data/www

# chown
chown worker.worker /home/worker
chown worker.worker /home/worker/data
chown worker.worker /home/worker/data/www
dotfile=`cd /home/worker && find . -maxdepth 1 -name '*' |sed -e 's#^.$##' -e 's#^.\/##' -e 's#^data$##'`
datadir=`cd /home/worker/data && find . -maxdepth 1 -name '*' |sed -e 's#^.$##' -e 's#^.\/##' -e 's#^www$##'`
cd /home/worker && chown -R  worker.worker $dotfile
cd /home/worker/data && chown -R  worker.worker $datadir

chown root.worker /home/worker/nginx/sbin/nginx
chmod u+s /home/worker/nginx/sbin/nginx

# Clean up APT when done.
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/worker/src/* 


