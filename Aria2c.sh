#!/bin/bash

Aria2cEXE=`which aria2c`
apt-get update
apt-get install -y libssl-dev libexpat1-dev libssh2-1-dev libc-ares-dev zlib1g-dev libsqlite3-dev pkg-config
if [[ "$Aria2cEXE" == "" ]]; then
cd /root
rm -rf aria2-*
wget wget --no-check-certificate -O aria2-release.tar.gz "https://github.com/aria2/aria2/archive/release-1.18.10.tar.gz"
tar -xvf aria2-*.tar.gz
cd aria2*
./configure --prefix=/usr/local --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt'
make && make install
rm -rf /root/aria2*
fi
rm -rf /root/.aria2 >/dev/null 2>&1
rm -rf /etc/aria2 >/dev/null 2>&1
mkdir -p /root/.aria2
mkdir -p /etc/aria2
wget --no-check-certificate -q -O /root/.aria2/dht.dat "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/.aria2/dht.dat"
wget --no-check-certificate -q -O /etc/aria2/aria2c "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c"
wget --no-check-certificate -q -O /etc/aria2/aria2c.conf "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c.conf"

chmod -R 755 /etc/aria2
chmod -R +X /etc/aria2
ln -sf /etc/aria2/aria2c /etc/init.d/aria2c
update-rc.d aria2c defaults
/etc/init.d/aria2c start
