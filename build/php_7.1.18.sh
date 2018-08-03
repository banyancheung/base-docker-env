#!/bin/bash
set -e
# -----------------------------------------------------------------------------
# Install re2c for PHP
# -----------------------------------------------------------------------------
cd /home/worker/src
wget -q -O re2c-1.0.3.tar.gz https://github.com/skvadrik/re2c/releases/download/1.0.3/re2c-1.0.3.tar.gz
tar xzf re2c-1.0.3.tar.gz
cd re2c-1.0.3
./configure
make
make install
rm -rf /home/worker/src/re2c*

# -----------------------------------------------------------------------------
# Install PHP
# -----------------------------------------------------------------------------
echo "---------- Installing PHP... ---------- "
cd /home/worker/src
mkdir -p /home/worker/php
wget -q -O php-7.1.18.tar.xz http://oss.ibos.cn/docker/resource/php/php-7.1.18.tar.xz
xz -d php-7.1.18.tar.xz
tar -xvf php-7.1.18.tar
cd php-7.1.18

# fix issue configure: error: Cannot find ldap.h
ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
&& ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so

./configure \
       --prefix=/home/worker/php \
       --with-config-file-path=/home/worker/php/etc \
       --with-config-file-scan-dir=/home/worker/php/etc/php.d \
       --sysconfdir=/home/worker/php/etc \
       --enable-mysqlnd \
       --enable-zip \
       --enable-exif \
       --enable-ftp \
       --enable-mbstring \
       --enable-mbregex \
       --enable-fpm \
       --enable-bcmath \
       --enable-pcntl \
       --enable-soap \
       --enable-sockets \
       --enable-shmop \
       --enable-sysvmsg \
       --enable-sysvsem \
       --enable-sysvshm \
       --enable-mysqlnd \
       --with-curl \
       --with-gettext \
       --with-xsl \
       --with-xmlrpc \
       --with-ldap \
       --with-mysqli=mysqlnd \
       --with-pdo-mysql=mysqlnd \
       --with-gd \
       --with-jpeg-dir \
       --with-png-dir \
       --with-zlib-dir \
       --with-freetype-dir \
       --with-pcre-regex \
       --with-zlib \
       --with-bz2 \
       --with-openssl \
       --with-mcrypt \
       --with-mhash 

make 1>/dev/null
make install
rm -rf /home/worker/php/lib/php.ini
cp -f php.ini-development /home/worker/php/lib/php.ini
rm -rf /home/worker/src/php*

echo "---------- Install PHP...done. ---------- "

# -----------------------------------------------------------------------------
# Install hiredis
# -----------------------------------------------------------------------------

echo "---------- Install hiredis... ---------- "
cd /home/worker/src
wget -q -O hiredis-0.13.3.tar.gz http://oss.ibos.cn/docker/resource/hiredis-0.13.3.tar.gz
tar zxvf hiredis-0.13.3.tar.gz
cd hiredis-0.13.3
make
make install
ldconfig
rm -rf /home/worker/src/hiredis-*
echo "---------- Install hiredis...done ---------- "

# -----------------------------------------------------------------------------
# Install libmemcached using by php-memcached
# -----------------------------------------------------------------------------

echo "---------- Install libmemcached... ---------- "
cd /home/worker/src
wget -q -O libmemcached-1.0.18.tar.gz http://oss.ibos.cn/docker/resource/libmemcached-1.0.18.tar.gz
tar xzf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
./configure --prefix=/usr/local --with-memcached 1>/dev/null
make 1>/dev/null
make install
rm -rf /home/worker/src/libmemcached*
echo "---------- Install libmemcached...done ---------- "

# -----------------------------------------------------------------------------
# Install yaml and PHP yaml extension
# -----------------------------------------------------------------------------
echo "---------- Install PHP yaml extension... ---------- "
cd /home/worker/src
wget -q -O yaml-2.0.2.tgz http://oss.ibos.cn/docker/resource/pecl/yaml-2.0.2.tgz
tar xzf yaml-2.0.2.tgz
cd yaml-2.0.2
/home/worker/php/bin/phpize
./configure --with-yaml=/usr/local --with-php-config=/home/worker/php/bin/php-config
make
make install
rm -rf /home/worker/src/yaml-*
echo "---------- Install PHP yaml extension...done. ---------- "

# -----------------------------------------------------------------------------
# Install PHP mongodb extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP mongodb extension... ---------- "
cd /home/worker/src
wget -q -O mongodb-1.4.2.tgz http://oss.ibos.cn/docker/resource/pecl/mongodb-1.4.2.tgz
tar zxf mongodb-1.4.2.tgz
cd mongodb-1.4.2
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make
make install
rm -rf /home/worker/src/mongodb-*
echo "---------- Install PHP mongodb extension...done. ---------- "

# -----------------------------------------------------------------------------
# Install PHP redis extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP redis extension... ---------- "
cd /home/worker/src
wget -q -O redis-4.0.1.tgz http://oss.ibos.cn/docker/resource/pecl/redis-4.0.1.tgz
tar zxf redis-4.0.1.tgz
cd redis-4.0.1
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/redis-*
echo "---------- Install PHP redis extension...done. ---------- "


# -----------------------------------------------------------------------------
# Install ImageMagick
# -----------------------------------------------------------------------------
cd /home/worker/src
wget -q -O ImageMagick.tar.gz http://oss.ibos.cn/docker/resource/ImageMagick.tar.gz
tar zxf ImageMagick.tar.gz
rm -rf ImageMagick.tar.gz
ImageMagickPath=`ls`
cd ${ImageMagickPath}
./configure
make
make install
rm -rf /home/worker/src/ImageMagick*
# -----------------------------------------------------------------------------
# Install PHP imagick extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP imagick extension... ---------- "
cd /home/worker/src
wget -q -O imagick-3.4.3.tgz http://oss.ibos.cn/docker/resource/pecl/imagick-3.4.3.tgz
tar zxf imagick-3.4.3.tgz
cd imagick-3.4.3
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config --with-imagick 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/imagick-*
echo "---------- Install PHP imagick extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP xdebug extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP xdebug extension... ---------- "
cd /home/worker/src
wget -q -O xdebug-2.6.0.tgz http://oss.ibos.cn/docker/resource/pecl/xdebug-2.6.0.tgz
tar zxf xdebug-2.6.0.tgz
cd xdebug-2.6.0
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/xdebug-*
echo "---------- Install PHP xdebug extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP igbinary extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP igbinary extension... ---------- "
cd /home/worker/src
wget -q -O igbinary-2.0.5.tgz http://oss.ibos.cn/docker/resource/pecl/igbinary-2.0.5.tgz
tar zxf igbinary-2.0.5.tgz
cd igbinary-2.0.5
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/igbinary-*
echo "---------- Install PHP igbinary extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP memcached extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP memcached extension... ---------- "
cd /home/worker/src
wget -q -O memcached-3.0.4.tgz http://oss.ibos.cn/docker/resource/pecl/memcached-3.0.4.tgz
tar xzf memcached-3.0.4.tgz
cd memcached-3.0.4
/home/worker/php/bin/phpize
./configure --enable-memcached --with-php-config=/home/worker/php/bin/php-config --with-libmemcached-dir=/usr/local/ --disable-memcached-sasl 1>/dev/null
make 1>/dev/null
make install
rm -rf /home/worker/src/memcached-*
echo "---------- Install PHP memcached extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP yac extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP yac extension... ---------- "
cd /home/worker/src
wget -q -O yac-2.0.2.tgz http://oss.ibos.cn/docker/resource/pecl/yac-2.0.2.tgz
tar zxf yac-2.0.2.tgz
cd yac-2.0.2
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config
make 1>/dev/null
make install
rm -rf /home/worker/src/yac-*
echo "---------- Install PHP yac extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP swoole extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP swoole extension... ---------- "
swooleVersion=2.2.0
cd /home/worker/src
wget -q -O swoole-${swooleVersion}.tar.gz http://oss.ibos.cn/docker/resource/swoole-src-${swooleVersion}.tar.gz
tar zxf swoole-${swooleVersion}.tar.gz
cd swoole-src-${swooleVersion}/
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config --enable-async-redis --enable-openssl
make clean 1>/dev/null
make 1>/dev/null
make install
rm -rf /home/worker/src/swoole*
echo "---------- Install PHP swoole extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP inotify extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP inotify extension... ---------- "
cd /home/worker/src
wget -q -O inotify-2.0.0.tgz http://oss.ibos.cn/docker/resource/pecl/inotify-2.0.0.tgz
tar zxf inotify-2.0.0.tgz
cd inotify-2.0.0
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/inotify-*
echo "---------- Install PHP inotify extension...done ---------- "

ln -s /home/worker/php/bin/php /usr/local/bin/php

echo "---------- Install Composer... ---------- "
curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && composer self-update --clean-backups
echo "---------- Install Composer...done ---------- "
