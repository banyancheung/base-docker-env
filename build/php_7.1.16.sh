#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# Install PHP
# -----------------------------------------------------------------------------
echo "---------- Installing PHP... ---------- " >> /build/build.log

mkdir -p /home/worker/php
wget -q -O php-7.1.16.tar.xz http://hk2.php.net/get/php-7.1.16.tar.xz/from/this/mirror
xz -d php-7.1.16.tar.xz
tar -xvf php-7.1.16.tar
cd php-7.1.16

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
       --with-curl \
       --with-gettext \
       --with-xsl \
       --with-xmlrpc \
       --with-ldap \
       --enable-mysqlnd \
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

make 1>/dev/null
make install
rm -rf /home/worker/php/lib/php.ini
cp -f php.ini-development /home/worker/php/lib/php.ini
rm -rf /home/worker/src/php*

echo "---------- Install PHP...done. ---------- " > /build/build.log

# -----------------------------------------------------------------------------
# Install hiredis
# -----------------------------------------------------------------------------

echo "---------- Install hiredis... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O hiredis-0.13.3.tar.gz https://github.com/redis/hiredis/archive/v0.13.3.tar.gz
tar zxvf hiredis-0.13.3.tar.gz
cd hiredis-0.13.3
make
make install
echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf
ldconfig
rm -rf /home/worker/src/hiredis-*
echo "---------- Install hiredis...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install yaml and PHP yaml extension
# -----------------------------------------------------------------------------
echo "---------- Install PHP yaml extension... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O yaml-2.0.2.tgz https://pecl.php.net/get/yaml-2.0.2.tgz
tar xzf yaml-2.0.2.tgz
cd yaml-2.0.2
/home/worker/php/bin/phpize
./configure --with-yaml=/usr/local --with-php-config=/home/worker/php/bin/php-config
make >/dev/null
make install
rm -rf /home/worker/src/yaml-*
echo "---------- Install PHP yaml extension...done. ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PHP mongodb extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP mongodb extension... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O mongodb-1.4.2.tgz https://pecl.php.net/get/mongodb-1.4.2.tgz
tar zxf mongodb-1.4.2.tgz
cd mongodb-1.4.2
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make
make install
rm -rf /home/worker/src/mongodb-*
echo "---------- Install PHP mongodb extension...done. ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PHP redis extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP redis extension... ---------- " >> /build/build.log
cd /home/worker/src \
wget -q -O redis-4.0.1.tgz https://pecl.php.net/get/redis-4.0.1.tgz
tar zxf redis-4.0.1.tgz
cd redis-4.0.1
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/redis-*
echo "---------- Install PHP redis extension...done. ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PHP imagick extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP imagick extension... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O imagick-3.4.3.tgz https://pecl.php.net/get/imagick-3.4.3.tgz
tar zxf imagick-3.4.3.tgz
cd imagick-3.4.3
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config --with-imagick 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/imagick-*
echo "---------- Install PHP imagick extension...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install libmemcached using by php-memcached
# -----------------------------------------------------------------------------

echo "---------- Install libmemcached... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O libmemcached-1.0.18.tar.gz https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar xzf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
./configure --prefix=/usr/local --with-memcached 1>/dev/null
make 1>/dev/null
make install
rm -rf /home/worker/src/libmemcached*
echo "---------- Install libmemcached...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PHP xdebug extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP xdebug extension... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O xdebug-2.6.0.tgz https://pecl.php.net/get/xdebug-2.6.0.tgz
tar zxf xdebug-2.6.0.tgz
cd xdebug-2.6.0
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/xdebug-*
echo "---------- Install PHP xdebug extension...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PHP igbinary extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP igbinary extension... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O igbinary-2.0.5.tgz https://pecl.php.net/get/igbinary-2.0.5.tgz
tar zxf igbinary-2.0.5.tgz
cd igbinary-2.0.5
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/igbinary-*
echo "---------- Install PHP igbinary extension...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PHP memcached extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP memcached extension... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O memcached-3.0.4.tgz https://pecl.php.net/get/memcached-3.0.4.tgz
tar xzf memcached-3.0.4.tgz
cd memcached-3.0.4
/home/worker/php/bin/phpize
./configure --enable-memcached --with-php-config=/home/worker/php/bin/php-config --with-libmemcached-dir=$LIB_MEMCACHED_INSTALL_DIR --disable-memcached-sasl 1>/dev/null
make 1>/dev/null
make install
rm -rf /home/worker/src/memcached-*
echo "---------- Install PHP memcached extension...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PHP yac extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP yac extension... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O yac-2.0.2.tgz https://pecl.php.net/get/yac-2.0.2.tgz
tar zxf yac-2.0.2.tgz
cd yac-2.0.2
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config
make 1>/dev/null
make install
rm -rf /home/worker/src/yac-*
echo "---------- Install PHP yac extension...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PHP swoole extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP swoole extension... ---------- " >> /build/build.log
swooleVersion = 2.1.3
cd /home/worker/src
wget -q -O swoole-${swooleVersion}.tar.gz https://github.com/swoole/swoole-src/archive/v${swooleVersion}.tar.gz
tar zxf swoole-${swooleVersion}.tar.gz \
cd swoole-src-${swooleVersion}/
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config --enable-async-redis --enable-openssl
make clean 1>/dev/null
make 1>/dev/null
make install
rm -rf /home/worker/src/swoole*
echo "---------- Install PHP swoole extension...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PHP inotify extensions
# -----------------------------------------------------------------------------

echo "---------- Install PHP inotify extension... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O inotify-2.0.0.tgz https://pecl.php.net/get/inotify-2.0.0.tgz
tar zxf inotify-2.0.0.tgz
cd inotify-2.0.0
/home/worker/php/bin/phpize
./configure --with-php-config=/home/worker/php/bin/php-config 1>/dev/null
make clean
make 1>/dev/null
make install
rm -rf /home/worker/src/inotify-*
echo "---------- Install PHP inotify extension...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install phpunit
# -----------------------------------------------------------------------------

echo "---------- Install phpunit... ---------- " >> /build/build.log
cd /home/worker/src
wget -q -O phpunit.phar https://phar.phpunit.de/phpunit.phar
mv phpunit.phar /home/worker/php/bin/phpunit
chmod +x /home/worker/php/bin/phpunit
echo "---------- Install phpunit...done ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install php composer
# -----------------------------------------------------------------------------

echo "---------- Install php composer... ---------- " >> /build/build.log
cd /home/worker/src
curl -sS https://getcomposer.org/installer | /home/worker/php/bin/php
chmod +x composer.phar
mv composer.phar /home/worker/php/bin/composer
echo "---------- Install php composer... ---------- " >> /build/build.log

# -----------------------------------------------------------------------------
# Install PhpDocumentor
# -----------------------------------------------------------------------------

echo "---------- Install PhpDocumentor... ---------- " >> /build/build.log
/home/worker/php/bin/pear install -a PhpDocumentor
cd /home/worker/php
bin/php bin/composer self-update
bin/pear install PHP_CodeSniffer-2.3.4
echo "---------- Install PhpDocumentor...done ---------- " >> /build/build.log

