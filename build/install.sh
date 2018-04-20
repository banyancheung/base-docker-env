#!/bin/sh
set -e

echo "---------- START BUILD PROCESS ----------" > build.log

./build/enable_repos.sh
./build/prepare.sh

### here is custom shell scripts
./build/php_7.1.16.sh
./build/apache_ab.sh
./build/git.sh
./build/nginx_1.12.2.sh


echo "---------- END BUILD PROCESS----------" > build.log

cat build.log
# Clean up APT when done.
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ${SRC_DIR}/* 


