#!/bin/bash

function Install-Check()
{
Aria2cEXE=`which aria2c`
UnZipEXE=`which unzip`
}

function Clean()
{
update-rc.d aria2c stop >/dev/null 2>&1
rm -rf /etc/init.d/aria2c >/dev/null 2>&1
rm -rf /etc/rc0.d/*aria2c >/dev/null 2>&1
rm -rf /etc/rc1.d/*aria2c >/dev/null 2>&1
rm -rf /etc/rc2.d/*aria2c >/dev/null 2>&1
rm -rf /etc/rc3.d/*aria2c >/dev/null 2>&1
rm -rf /etc/rc4.d/*aria2c >/dev/null 2>&1
rm -rf /etc/rc5.d/*aria2c >/dev/null 2>&1
rm -rf /etc/rc6.d/*aria2c >/dev/null 2>&1
rm -rf /usr/local/share/man/man1/aria2c.1 >/dev/null 2>&1
rm -rf /usr/local/share/man/pt/man1/aria2c.1 >/dev/null 2>&1
rm -rf /usr/local/share/man/ru/man1/aria2c.1 >/dev/null 2>&1
rm -rf /usr/local/bin/aria2c >/dev/null 2>&1
rm -rf /etc/aria2 >/dev/null 2>&1
apt-get purge -y aria2 >/dev/null 2>&1
apt-get autoremove -y aria2 >/dev/null 2>&1
Aria2cEXE=""
}

function Install-by-itself()
{
apt-get update
apt-get install -y aria2
}

function Install-by-yourself()
{
cd /root
apt-get update
apt-get install -y libgnutls-dev nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev libgpg-error-dev pkg-config ca-certificates
apt-get install -y libcppunit-dev autoconf automake autotools-dev autopoint libtool
apt-get install -y libgcrypt-dev libssl-dev libexpat1-dev
rm -rf /root/aria2-*
wget --no-check-certificate -q -O aria2-release.tar.gz "http://http.debian.net/debian/pool/main/a/aria2/$Ver"
tar -xvf aria2-release.tar.gz
cd aria2*
sed -i s'/1\, 16\,/1\, 64\,/' ./src/OptionHandlerFactory.cc
autoreconf -i
./configure --prefix=/usr --with-libxml2 --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt'
make && make install
rm -rf /root/aria2*
}

function Install-WEB()
{
[ -z "$UnZipEXE" ] && apt-get install -y unzip
rm -rf /root/.aria2 >/dev/null 2>&1
rm -rf /etc/aria2 >/dev/null 2>&1
mkdir -p /root/.aria2
mkdir -p /etc/aria2
mkdir -p /etc/aria2/web
wget --no-check-certificate -q -O /root/Aria2c.zip "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/Aria2c.zip"
wget --no-check-certificate -q -O /root/.aria2/dht.dat "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/.aria2/dht.dat"
wget --no-check-certificate -q -O /etc/aria2/aria2c "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c"
wget --no-check-certificate -q -O /etc/aria2/aria2c.conf "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c.conf"
unzip -d /etc/aria2/web /root/Aria2c.zip >/dev/null 2>&1
rm -rf /root/Aria2c.zip >/dev/null 2>&1
}

Install-Check;
if [[ "$1" == 'clean' ]]; then
Clean;
elif [[ "$1" == 'manual' ]]; then
Clean;
Ver="aria2_1.15.1.orig.tar.bz2"
[ "$2" == '1.15.1' ] && Ver="aria2_1.15.1.orig.tar.bz2"
[ "$2" == '1.18.8' ] && Ver="aria2_1.18.8.orig.tar.bz2"
[ "$2" == '1.27.1' ] && Ver="aria2_1.27.1.orig.tar.gz"
Install-by-yourself;
else
Install-by-itself;
fi
Install-WEB;

chmod -R 755 /etc/aria2
chmod +x /etc/aria2/aria2c
ln -sf /etc/aria2/aria2c /etc/init.d/aria2c
sleep 3
update-rc.d aria2c defaults
/etc/init.d/aria2c start
