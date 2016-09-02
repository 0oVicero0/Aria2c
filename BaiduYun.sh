#!/bin/bash

function Hello()
{
CheckEXE=`which bypy.py`
CheckPS=`ps -e |grep "bypy.py"`
if [[ $CheckEXE != "" ]]; then
if [[ $CheckPS == "" ]]; then
CreatList;
else
exit 1
fi fi
}

function CreatList()
{
rm -rf /usr/share/nginx/www/list.txt >/dev/null 2>&1
rm -rf /usr/share/nginx/www/nolist.txt >/dev/null 2>&1
dir /usr/share/nginx/www/download > /usr/share/nginx/www/list.txt
dir /usr/share/nginx/www/download |awk "/\.aria2/" |awk -F '.aria2' '{ print $1 }' > /usr/share/nginx/www/nolist.txt
UpLoadFile;
}

function UpLoadFile()
{
NoList=`sed -n 1p /usr/share/nginx/www/nolist.txt`
if [[ $NoList != "" ]]; then
sed -i "/$NoList/"d /usr/share/nginx/www/list.txt
fi
sed -i '/^$/'d /usr/share/nginx/www/list.txt
UpFile=`sed -n 1p /usr/share/nginx/www/list.txt`
if [[ $UpFile != "" ]]; then
python $CheckEXE -v upload "/usr/share/nginx/www/download/$UpFile"
sed -i "/$UpFile/"d /usr/share/nginx/www/list.txt
UpLoadFile;
else
rm -rf /usr/share/nginx/www/list.txt >/dev/null 2>&1
rm -rf /usr/share/nginx/www/nolist.txt >/dev/null 2>&1
exit 1
fi
}

Hello;