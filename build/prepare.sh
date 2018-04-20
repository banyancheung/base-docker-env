#!/bin/bash
set -e

echo "---------- Performing miscellaneous preparation... ----------" >> build.log

# -----------------------------------------------------------------------------
# Devel libraries for delelopment tools like php & nginx ...
# -----------------------------------------------------------------------------
apt-get -y install gcc-4.8 g++-4.8 xz-utils wget tzdata tar make curl libfcgi-dev libfcgi0ldbl libmcrypt-dev libssl-dev libc-client2007e libpng12-dev \
libc-client2007e-dev libbz2-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libkrb5-dev libpq-dev libxml2-dev libfreetype6-dev imagemagick \
libxslt1-dev openssl build-essential libexpat1-dev libgeoip-dev libpcre3-dev rcs zlib1g-dev libwebp-dev pkg-config libldb-dev libldap2-dev

# -----------------------------------------------------------------------------
# Make src dir
# -----------------------------------------------------------------------------

export HOME=/home/worker
export SRC_DIR=$HOME/src
mkdir -p ${SRC_DIR}

# -----------------------------------------------------------------------------
# Configure, timezone/passwd/networking
# -----------------------------------------------------------------------------

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
echo "root:root" | chpasswd

# -----------------------------------------------------------------------------
# Add user worker
# -----------------------------------------------------------------------------
useradd -M -u 1000 worker
echo "worker:worker" | chpasswd
echo 'worker  ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers