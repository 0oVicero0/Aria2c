#!/bin/bash

Aria2cEXE=`which aria2c`
if [[ "$Aria2cEXE" == "" ]]; then
apt-get update
apt-get install -y aria2
fi

rm -rf /root/.aria2 >/dev/null 2>&1
rm -rf /etc/aria2 >/dev/null 2>&1
mkdir -p /root/.aria2
mkdir -p /etc/aria2

wget --no-check-certificate -q -O /root/.aria2/dht.dat "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/.aria/dht.dat"
wget --no-check-certificate -q -O /etc/aria2/aria2c "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c"
wget --no-check-certificate -q -O /etc/aria2/aria2c.conf "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/aria2c.conf"

chmod -R 755 /etc/aria2
chmod -R +X /etc/aria2
ln -sf /etc/aria2/aria2c /etc/init.d/aria2c
update-rc.d aria2c defaults
/etc/init.d/aria2c start
