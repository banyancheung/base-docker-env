#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# Devel libraries for delelopment tools like php & nginx ...
# -----------------------------------------------------------------------------
echo "---------- Preparing APT repositories ----------"
cd /etc/apt
cp sources.list sources.list.bak

echo deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse > /etc/apt/sources.list
echo deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse >> /etc/apt/sources.list
echo deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse >> /etc/apt/sources.list
echo deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse >> /etc/apt/sources.list

apt-get update
apt-get -y install file gcc g++ xz-utils wget tzdata tar make curl libfcgi-dev libfcgi0ldbl libmcrypt-dev libssl-dev libc-client2007e \
libc-client2007e-dev libbz2-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libkrb5-dev libpq-dev libxml2-dev libfreetype6-dev imagemagick \
libxslt1-dev openssl build-essential libexpat1-dev libgeoip-dev libpcre3-dev rcs zlib1g-dev libwebp-dev pkg-config libldb-dev autoconf libnghttp2-dev \
libyaml-dev unzip libz-dev libevent-dev

# -----------------------------------------------------------------------------
# Configure, timezone/passwd/networking
# -----------------------------------------------------------------------------
echo "---------- Configure, timezone/passwd/networking... ---------- "
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' > /etc/timezone
echo "root:root" | chpasswd
echo "---------- Configure, timezone/passwd/networking...done ---------- "
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Add user worker
# -----------------------------------------------------------------------------
useradd -M -u 1000 worker
echo "worker:worker" | chpasswd
echo 'worker  ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers