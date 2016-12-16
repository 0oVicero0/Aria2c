#!/bin/bash

function Install-Check()
{
Aria2cEXE=`which aria2c`
}

function Clean()
{
update-rc.d -f aria2 remove
rm -rf /usr/local/share/man/man1/aria2c* >/dev/null 2>&1
rm -rf /usr/local/share/man/pt/man1/aria2c* >/dev/null 2>&1
rm -rf /usr/local/share/man/ru/man1/aria2c* >/dev/null 2>&1
rm -rf /usr/local/bin/aria2c >/dev/null 2>&1
rm -rf /etc/aria2 >/dev/null 2>&1
apt-get purge -y aria2 >/dev/null 2>&1
apt-get autoremove -y aria2 >/dev/null 2>&1
rm -rf /root/aria2* >/dev/null 2>&1
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
apt-get install -y libgnutls-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev libgpg-error-dev pkg-config ca-certificates
apt-get install -y libcppunit-dev autoconf automake autotools-dev autopoint libtool
apt-get install -y libgcrypt-dev libssl-dev libexpat1-dev
rm -rf /root/aria2-*
wget --no-check-certificate -q -O aria2-release.tar.gz "http://http.debian.net/debian/pool/main/a/aria2/$Ver"
tar -xvf aria2-release.tar.gz
cd aria2*
autoreconf -i
./configure --prefix=/usr/local --with-libxml2 --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt'
make && make install
rm -rf /root/aria2*
}

function Install-Auto()
{
CleanAuto && sleep 3
chmod -R 755 /etc/aria2/
chmod +x /etc/aria2/aria2c
chmod 777 /etc/aria2/aria2c
ln -sf /etc/aria2/aria2c /usr/local/bin/aria2
update-rc.d -f aria2 remove
update-rc.d aria2 defaults
fi
}

Install-Check;
if [[ "$1" == 'clean' ]]; then
Clean;
exit 1
elif [[ "$1" == 'manual' ]]; then
Clean;
Ver="aria2_1.15.1.orig.tar.bz2"
[ "$2" == '1.15.1' ] && Ver="aria2_1.15.1.orig.tar.bz2"
[ "$2" == '1.18.8' ] && Ver="aria2_1.18.8.orig.tar.bz2"
[ "$2" == '1.27.1' ] && Ver="aria2_1.27.1.orig.tar.gz"
Install-by-itself && Clean;
Install-by-yourself;
else
Install-by-itself;
fi
Install-Auto;
 

