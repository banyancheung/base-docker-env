#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# Devel libraries for delelopment tools like php & nginx ...
# -----------------------------------------------------------------------------
echo "---------- Preparing APT repositories ----------" >> /build/build.log
cd /etc/apt
cp sources.list sources.list.bak

echo deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse > /etc/apt/sources.list
echo deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse >> /etc/apt/sources.list
echo deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse >> /etc/apt/sources.list
echo deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse >> /etc/apt/sources.list

apt-get update
apt-get -y install file gcc g++ xz-utils wget tzdata tar make curl libfcgi-dev libfcgi0ldbl libmcrypt-dev libssl-dev libc-client2007e libpng12-dev \
libc-client2007e-dev libbz2-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libkrb5-dev libpq-dev libxml2-dev libfreetype6-dev imagemagick \
libxslt1-dev openssl build-essential libexpat1-dev libgeoip-dev libpcre3-dev rcs zlib1g-dev libwebp-dev pkg-config libldb-dev libldap2-dev autoconf \
libyaml-dev unzip

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