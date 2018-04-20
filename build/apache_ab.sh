#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# Install Apache ab
# -----------------------------------------------------------------------------
echo "---------- Install apache ab.. ----------" >> /build/build.log

apt-get install -y apache2-utils

echo "---------- Install apache ab..done ----------" >> /build/build.log