#!/bin/bash

function Install-by-yourself()
{
rm -rf /usr/local/share/man/man1/aria2c.1 >/dev/null 2>&1
rm -rf /usr/local/share/man/pt/man1/aria2c.1 >/dev/null 2>&1
rm -rf /usr/local/share/man/ru/man1/aria2c.1 >/dev/null 2>&1
rm -rf /usr/local/bin/aria2c >/dev/null 2>&1
apt-get install -y libc-ares2 libc6 libgcc1 libgmp10 libgnutls-deb0-28 libnettle4 libsqlite3-0 libstdc++6 libxml2 zlib1g libgnutls-dev libgcrypt-dev libssl-dev libexpat1-dev libssh2-1-dev libc-ares-dev zlib1g-dev libsqlite3-dev pkg-config ca-certificates
cd /root
rm -rf aria2-*
wget --no-check-certificate -O aria2-release.tar.gz "http://http.debian.net/debian/pool/main/a/aria2/aria2_1.18.8.orig.tar.bz2"
tar -xvf aria2-*.tar.gz
cd aria2*
sed -i s'/1\, 16\,/1\, 64\,/' ./src/OptionHandlerFactory.cc
./configure --prefix=/usr/local --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt'
make && make install
rm -rf /root/aria2*
}

function Install-by-itself()
{
apt-get install -y aria2
}

Aria2cEXE=`which aria2c`
UnZipEXE=`which unzip`

function Clean()
{
rm -rf /usr/local/share/man/man1/aria2c.1 >/dev/null 2>&1
rm -rf /usr/local/share/man/pt/man1/aria2c.1 >/dev/null 2>&1
rm -rf /usr/local/share/man/ru/man1/aria2c.1 >/dev/null 2>&1
rm -rf /usr/local/bin/aria2c >/dev/null 2>&1
Aria2cEXE=""
}

if [[ "$1" == 'clean' ]]; then
Clean;
fi
if [[ "$Aria2cEXE" == "" ]]; then
apt-get update
if [[ "$1" == 'manual' ]]; then
Clean;
Install-by-yourself;
else
Install-by-itself;
fi fi

if [[ "$UnZipEXE" == "" ]]; then
apt-get install -y unzip
fi

rm -rf /root/.aria2 >/dev/null 2>&1
rm -rf /etc/aria2 >/dev/null 2>&1
mkdir -p /root/.aria2
mkdir -p /etc/aria2
mkdir -p /etc/aria2/web
wget --no-check-certificate -q -O /root/Aria2c.zip "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/Aria2c.zip"
wget --no-check-certificate -q -O /root/.aria2/dht.dat "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/.aria2/dht.dat"
wget --no-check-certificate -q -O /etc/aria2/aria2c "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c"
wget --no-check-certificate -q -O /etc/aria2/aria2c.conf "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c.conf"

unzip -d /etc/aria2/web /root/Aria2c.zip
rm -rf /root/Aria2c.zip >/dev/null 2>&1

chmod -R 755 /etc/aria2
chmod -R +X /etc/aria2
ln -sf /etc/aria2/aria2c /etc/init.d/aria2c
update-rc.d aria2c defaults
/etc/init.d/aria2c start
