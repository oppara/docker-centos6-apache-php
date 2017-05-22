#!/bin/bash
set -eu

dir=/usr/src/php
if [ ! -d $dir ]; then
  mkdir -p $dir
fi

. "/root/tmp/php${VERSION}.sh"

cd $dir
wget -q --trust-server-names http://jp2.php.net/get/php-${PHP_VERSION}.tar.gz/from/this/mirror
tar xzf php-${PHP_VERSION}.tar.gz
cd  php-${PHP_VERSION}

install_php

cp php.ini-development /etc/php.ini

if [[ -n "${XDEBUG_VERSION+x}" ]]; then
  echo "Install Xdebug ${XDEBUG_VERSION}"
  cd $dir
  wget -q http://xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz
  tar xzf xdebug-${XDEBUG_VERSION}.tgz
  cd xdebug-${XDEBUG_VERSION^^}
  /usr/local/bin/phpize
  ./configure --enable-xdebug  --with-php-config=/usr/local/bin/php-config
  make
  mkdir -p /usr/local/lib/php/extensions/
  cp modules/xdebug.so /usr/local/lib/php/extensions/

  echo "" >> /etc/php.ini
  echo "; xdebug" >> /etc/php.ini
  echo "zend_extension=/usr/local/lib/php/extensions/xdebug.so" >> /etc/php.ini
fi


if [[ -n "${APC_VERSION+x}" ]]; then
  echo "Install APC ${APC_VERSION}"
  cd $dir
  wget -q http://pecl.php.net/get/APC-${APC_VERSION}.tgz
  tar xzf APC-${APC_VERSION}.tgz
  cd APC-${APC_VERSION^^}
  /usr/local/bin/phpize
  ./configure --enable-apc  --with-php-config=/usr/local/bin/php-config
  make
  make install

  echo "" >> /etc/php.ini
  echo "; apc" >> /etc/php.ini
  echo "extension=apc.so" >> /etc/php.ini
  echo "apc.enabled=1" >> /etc/php.ini
  echo "apc.shm_size=128M" >> /etc/php.ini
  echo "apc.ttl=7200" >> /etc/php.ini
  echo "apc.user_ttl=7200" >> /etc/php.ini
fi

rm -rf $dir
