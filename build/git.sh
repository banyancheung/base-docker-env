#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# Install Git
# -----------------------------------------------------------------------------
echo "---------- Install git... ----------" >> /build/build.log

cd ${SRC_DIR}
apt-get -y remove git
wget -q -O git-2.17.0.tar.gz https://github.com/git/git/archive/v2.17.0.tar.gz
tar zxf git-2.17.0.tar.gz
cd git-2.17.0
make configure
./configure --without-iconv --prefix=/usr/local/ --with-curl
make install
rm -rf $SRC_DIR/git-2*

echo "---------- Install git...done ----------" >> /build/build.log