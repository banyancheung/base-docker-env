#!/bin/bash
set -e

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

