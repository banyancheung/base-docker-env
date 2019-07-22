#!/bin/bash
set -e

# Version
PHPREDIS_VERSION=5.0.0
MEMCACHED_VERSION=3.1.3
HIREDIS_VERSION=0.14.0
SWOOLE_VERSION=4.4.1
PHP_VERSION=7.1.30
XDEBUG_VERSION=2.7.2
RE2C_VERSION=1.1.1
IGBINARY_VERSION=3.0.1
YAML_VERSION=2.0.4
MONGODB_VERSION=1.5.5
YAF_VERSION=3.0.8
IMAGEMAGICK_VERSION=7.0.8
IMAGEMAGICK_EXT_VERSION=3.4.4
LIBMEMCACHED_VERSION=1.0.18
IONOTIFY_VERSION=2.0.0
EVENT_VERSION=2.5.3

# -----------------------------------------------------------------------------
# Install re2c for PHP
# -----------------------------------------------------------------------------
cd /home/worker/src
wget -q -O re2c-${RE2C_VERSION}.tar.gz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/re2c-${RE2C_VERSION}.tar.gz
tar xzf re2c-${RE2C_VERSION}.tar.gz
cd re2c-${RE2C_VERSION}
./configure
make -j$(nproc)
make install
rm -rf /home/worker/src/re2c*

# -----------------------------------------------------------------------------
# Install PHP
# -----------------------------------------------------------------------------
echo "---------- Installing PHP... ---------- "
cd /home/worker/src
mkdir -p /home/worker/php
wget -q -O php-${PHP_VERSION}.tar.xz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/php-${PHP_VERSION}.tar.xz
xz -d php-${PHP_VERSION}.tar.xz
tar -xvf php-${PHP_VERSION}.tar
cd php-${PHP_VERSION}

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
       --enable-fileinfo \
       --with-curl \
       --with-iconv \
       --with-gettext \
       --with-xsl \
       --with-xmlrpc \
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
       --with-mhash 

make -j$(nproc)
make install
rm -rf /home/worker/php/lib/php.ini
cp -f php.ini-development /home/worker/php/lib/php.ini
rm -rf /home/worker/src/php*

echo "---------- Install PHP...done. ---------- "

# -----------------------------------------------------------------------------
# Install PHP igbinary extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP igbinary extension... ---------- "
cd /home/worker/src
wget -q -O igbinary-${IGBINARY_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/igbinary-${IGBINARY_VERSION}.tgz
tar zxf igbinary-${IGBINARY_VERSION}.tgz
cd igbinary-${IGBINARY_VERSION}
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config
make clean
make -j$(nproc)
make install
rm -rf /home/worker/src/igbinary-*
echo "---------- Install PHP igbinary extension...done ---------- "

# -----------------------------------------------------------------------------
# Install libmemcached using by php-memcached
# -----------------------------------------------------------------------------
# use my own fixed version,see https://bugs.launchpad.net/libmemcached/+bug/1663985
echo "---------- Install libmemcached... ---------- "
cd /home/worker/src
wget -q -O libmemcached-${LIBMEMCACHED_VERSION}.zip https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/libmemcached-${LIBMEMCACHED_VERSION}.zip
unzip libmemcached-${LIBMEMCACHED_VERSION}.zip
chmod +x -R libmemcached-${LIBMEMCACHED_VERSION}
cd libmemcached-${LIBMEMCACHED_VERSION}
./configure --prefix=/usr/local --with-memcached
make -j$(nproc)
make install
rm -rf /home/worker/src/libmemcached*
echo "---------- Install libmemcached...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP memcached extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP memcached extension... ---------- "
cd /home/worker/src
wget -q -O memcached-${MEMCACHED_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/memcached-${MEMCACHED_VERSION}.tgz
tar xzf memcached-${MEMCACHED_VERSION}.tgz
cd memcached-${MEMCACHED_VERSION}
/home/worker/php/bin/phpize
./configure --enable-memcached --with-php-config=/home/worker/php/bin/php-config --with-libmemcached-dir=/usr/local/ --disable-memcached-sasl 1>/dev/null
make -j$(nproc)
make install
rm -rf /home/worker/src/memcached-*
echo "---------- Install PHP memcached extension...done ---------- "

# -----------------------------------------------------------------------------
# Install yaml and PHP yaml extension
# -----------------------------------------------------------------------------
echo "---------- Install PHP yaml extension... ---------- "
cd /home/worker/src
wget -q -O yaml-${YAML_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/yaml-${YAML_VERSION}.tgz
tar xzf yaml-${YAML_VERSION}.tgz
cd yaml-${YAML_VERSION}
/home/worker/php/bin/phpize
./configure --with-yaml=/usr/local --with-php-config=/home/worker/php/bin/php-config
make -j$(nproc)
make install
rm -rf /home/worker/src/yaml-*
echo "---------- Install PHP yaml extension...done. ---------- "

# -----------------------------------------------------------------------------
# Install PHP mongodb extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP mongodb extension... ---------- "
cd /home/worker/src
wget -q -O mongodb-${MONGODB_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/mongodb-${MONGODB_VERSION}.tgz
tar zxf mongodb-${MONGODB_VERSION}.tgz
cd mongodb-${MONGODB_VERSION}
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config
make clean
make -j$(nproc)
make install
rm -rf /home/worker/src/mongodb-*
echo "---------- Install PHP mongodb extension...done. ---------- "

# -----------------------------------------------------------------------------
# Install PHP inotify extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP inotify extension... ---------- "
cd /home/worker/src
wget -q -O inotify-${IONOTIFY_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/inotify-${IONOTIFY_VERSION}.tgz
tar zxf inotify-${IONOTIFY_VERSION}.tgz
cd inotify-${IONOTIFY_VERSION}
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config
make clean
make -j$(nproc)
make install
rm -rf /home/worker/src/inotify-*
echo "---------- Install PHP inotify extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP yaf extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP yaf extension... ---------- "
cd /home/worker/src
wget -q -O yaf-${YAF_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/yaf-${YAF_VERSION}.tgz
tar zxf yaf-${YAF_VERSION}.tgz
cd yaf-${YAF_VERSION}
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config
make -j$(nproc)
make install
rm -rf /home/worker/src/yaf-*
echo "---------- Install PHP yaf extension...done ---------- "

# -----------------------------------------------------------------------------
# Install hiredis
# -----------------------------------------------------------------------------

echo "---------- Install hiredis... ---------- "
cd /home/worker/src
wget -q -O hiredis-${HIREDIS_VERSION}.tar.gz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/hiredis-${HIREDIS_VERSION}.tar.gz
tar zxf hiredis-${HIREDIS_VERSION}.tar.gz
cd hiredis-${HIREDIS_VERSION}
make -j$(nproc)
make install
ldconfig
rm -rf /home/worker/src/hiredis-*
echo "---------- Install hiredis...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP redis extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP redis extension... ---------- "
cd /home/worker/src
wget -q -O redis-${PHPREDIS_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/redis-${PHPREDIS_VERSION}.tgz
tar zxf redis-${PHPREDIS_VERSION}.tgz
cd redis-${PHPREDIS_VERSION}
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config
make clean
make -j$(nproc)
make install
rm -rf /home/worker/src/redis-*
echo "---------- Install PHP redis extension...done. ---------- "


# -----------------------------------------------------------------------------
# Install ImageMagick
# -----------------------------------------------------------------------------
cd /home/worker/src
mkdir -p imagemagick
wget -q -O ImageMagick.tar.gz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz
tar -xf ImageMagick.tar.gz -C imagemagick --strip-components=1
rm -rf ImageMagick.tar.gz
ImageMagickPath=`ls`
cd imagemagick
./configure
make -j$(nproc)
make install
ldconfig /usr/local/lib
rm -rf /home/worker/src/imagemagick
# -----------------------------------------------------------------------------
# Install PHP imagick extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP imagick extension... ---------- "
cd /home/worker/src
wget -q -O imagick-${IMAGEMAGICK_EXT_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/imagick-${IMAGEMAGICK_EXT_VERSION}.tgz
tar zxf imagick-${IMAGEMAGICK_EXT_VERSION}.tgz
cd imagick-${IMAGEMAGICK_EXT_VERSION}
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config --with-imagick
make clean
make -j$(nproc)
make install
rm -rf /home/worker/src/imagick-*
echo "---------- Install PHP imagick extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP xdebug extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP xdebug extension... ---------- "
cd /home/worker/src
wget -q -O xdebug-${XDEBUG_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/xdebug-${XDEBUG_VERSION}.tgz
tar zxf xdebug-${XDEBUG_VERSION}.tgz
cd xdebug-${XDEBUG_VERSION}
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config
make clean
make -j$(nproc)
make install
rm -rf /home/worker/src/xdebug-*
echo "---------- Install PHP xdebug extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP event extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP event extension... ---------- "
cd /home/worker/src
wget -q -O event-${EVENT_VERSION}.tgz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/event-${EVENT_VERSION}.tgz
tar zxf event-${EVENT_VERSION}.tgz
cd event-${EVENT_VERSION}
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config
make clean
make -j$(nproc)
make install
rm -rf /home/worker/src/event-*
echo "---------- Install PHP event extension...done ---------- "

# -----------------------------------------------------------------------------
# Install PHP swoole extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP swoole extension... ---------- "
cd /home/worker/src
wget -q -O swoole-${SWOOLE_VERSION}.tar.gz https://mrzfiles.oss-cn-shenzhen.aliyuncs.com/resource/swoole-src-${SWOOLE_VERSION}.tar.gz
tar zxf swoole-${SWOOLE_VERSION}.tar.gz
cd swoole-src-${SWOOLE_VERSION}/
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config --enable-openssl --enable-http2 --enable-mysqlnd
make clean
make -j$(nproc)
make install
rm -rf /home/worker/src/swoole*
echo "---------- Install PHP swoole extension...done ---------- "

ln -s /home/worker/php/bin/php /usr/local/bin/php

echo "---------- Install Composer... ---------- "
export COMPOSER_HOME=/home/worker/
wget https://getcomposer.org/download/1.8.6/composer.phar -O /usr/local/bin/composer
chmod a+x /usr/local/bin/composer
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
echo "---------- Install Composer...done ---------- "
