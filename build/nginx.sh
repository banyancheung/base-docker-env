#!/bin/bash
set -e

nginx_version=1.16.0
NGINX_INSTALL_DIR=/home/worker/nginx
apt-get -y install unzip
cd /home/worker/src
wget -q -O nginx-${nginx_version}.tar.gz http://nginx.org/download/nginx-${nginx_version}.tar.gz
wget -q -O nginx-http-concat.zip https://github.com/alibaba/nginx-http-concat/archive/master.zip
wget -q -O nginx-logid.zip https://github.com/pinguo-liuzhaohui/nginx-logid/archive/master.zip
tar zxf nginx-${nginx_version}.tar.gz
unzip nginx-http-concat.zip -d nginx-http-concat
unzip nginx-logid.zip -d nginx-logid
cd /home/worker/src/nginx-${nginx_version}
./configure --prefix=$NGINX_INSTALL_DIR --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module \
       --add-module=../nginx-http-concat/nginx-http-concat-master --add-module=../nginx-logid/nginx-logid-master 1>/dev/null
make 1>/dev/null
make install
rm -rf /home/worker/src/nginx-*