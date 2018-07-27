#!/bin/bash
set -e

nginx_version=1.12.2
NGINX_INSTALL_DIR=/home/worker/nginx
apt-get -y install unzip
cd /home/worker/src
wget -q -O nginx-${nginx_version}.tar.gz http://nginx.org/download/nginx-${nginx_version}.tar.gz
wget -q -O nginx-http-concat.zip https://github.com/alibaba/nginx-http-concat/archive/master.zip
wget -q -O nginx-logid.zip https://github.com/pinguo-liuzhaohui/nginx-logid/archive/master.zip
wget -q -O ngx_devel_kit-0.3.0.tar.gz https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz
wget -q -O lua-nginx-module-0.10.11.tar.gz https://github.com/openresty/lua-nginx-module/archive/v0.10.11.tar.gz
wget -q -O LuaJIT-2.0.5.tar.gz http://luajit.org/download/LuaJIT-2.0.5.tar.gz
tar zxf nginx-${nginx_version}.tar.gz
unzip nginx-http-concat.zip -d nginx-http-concat
unzip nginx-logid.zip -d nginx-logid
tar zxf ngx_devel_kit-0.3.0.tar.gz
tar zxf lua-nginx-module-0.10.11.tar.gz
tar zxf LuaJIT-2.0.5.tar.gz
cd LuaJIT-2.0.5
make PREFIX=/home/worker/LuaJIT-2.0.5 1>/dev/null
make install PREFIX=/home/worker/LuaJIT-2.0.5
cd /home/worker
ln -s LuaJIT-2.0.5 luajit
export LUAJIT_LIB=/home/worker/luajit/lib
export LUAJIT_INC=/home/worker/luajit/include/luajit-2.0
cd /home/worker/src/nginx-${nginx_version}
./configure --prefix=/home/worker/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module \
       --add-module=../nginx-http-concat/nginx-http-concat-master --add-module=../nginx-logid/nginx-logid-master \
       --with-ld-opt="-Wl,-rpath,/home/worker/luajit/lib" --add-module=../ngx_devel_kit-0.3.0 --add-module=../lua-nginx-module-0.10.11 1>/dev/null
make 1>/dev/null
make install
rm -rf /home/worker/src/nginx-* /home/worker/src/ngx_devel_kit* /home/worker/src/lua-nginx-module* /home/worker/src/LuaJIT*