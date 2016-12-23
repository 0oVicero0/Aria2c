#!/bin/bash

function Clean()
{
update-rc.d -f aria2 remove
rm -rf /usr/local/share/man/man1/aria2c* >/dev/null 2>&1
rm -rf /usr/local/share/man/pt/man1/aria2c* >/dev/null 2>&1
rm -rf /usr/local/share/man/ru/man1/aria2c* >/dev/null 2>&1
rm -rf /usr/local/bin/aria2c >/dev/null 2>&1
rm -rf /etc/aria2 >/dev/null 2>&1
rm -rf /root/.aria2 >/dev/null 2>&1
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

function APTINSTALL(){
    for DEB_IN in ${1}
    do
        echo -n -e "Installing package\e[36m ${DEB_IN} \e[0m"
        apt-get install -qq -y ${2} ${DEB_IN} >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "[\e[32mok\e[0m]"
        else
            [ -n "${2}" ] && apt-get install -qq -y ${DEB_IN} >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo -e "[\e[32mok\e[0m]"
            else
                echo -e "[\e[31mfail\e[0m]"
        fi fi
    done
}

function Install-by-yourself()
{
cd /root
[ -n "$(uname -r |grep '3.2.0-4')" ] && DEB_VER='7';
[ -n "$(uname -r |grep '3.16.0-4')" ] && DEB_VER='8';
APTINSTALL "build-essential make gcc autoconf automake autotools-dev autopoint libtool libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev libgpg-error-dev pkg-config ca-certificates libcppunit-dev libssl-dev libexpat1-dev"
[ "$DEB_VER" == '8' ] && APTINSTALL "libgcrypt20-dev"
[ "$DEB_VER" == '7' ] && APTINSTALL "libgnutls-dev libgcrypt11-dev"
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
mkdir -p /etc/aria2
mkdir -p /root/.aria2
wget -O /etc/aria2/aria2c 'https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c'
wget -O /etc/aria2/aria2c.conf 'https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c.conf'
chmod -R 755 /etc/aria2/
chmod +x /etc/aria2/aria2c
chmod 777 /etc/aria2/aria2c
cp -f /etc/aria2/aria2c /etc/init.d/aria2
update-rc.d -f aria2 remove
update-rc.d aria2 defaults
}

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
Install-Auto;
else
Install-by-itself;
fi

 

