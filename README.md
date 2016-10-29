# Aria2c
----------------------------------------------------------------------------
----------------------------------------------------------------------------
Debian Aria2c
```
wget --no-check-certificate -O Aria2c.sh "https://raw.githubusercontent.com/0oVicero0/Aria2c/master/Aria2c.sh" && chmod +X Aria2c.sh && bash Aria2c.sh
    
```
----------------------------------------------------------------------------
----------------------------------------------------------------------------
ffmpeg
```
echo "deb ftp://ftp.deb-multimedia.org wheezy main" >>/etc/apt/sources.list
apt-get update
apt-get install -y --force-yes deb-multimedia-keyring
apt-get update
apt-get install -y ffmpeg

```
----------------------------------------------------------------------------
----------------------------------------------------------------------------
Python3 (#!/usr/local/bin/python3)
```
wget -O Python3.tgz "https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz"
tar -xzvf Python3.tgz
cd Python-3*
./configure --prefix=/usr/local
make && make install
pip3 install --upgrade pip
pip3 install requests

```
----------------------------------------------------------------------------
----------------------------------------------------------------------------
