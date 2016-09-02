#!/bin/bash

function Hello()
{
CheckEXE=`echo $0 |awk -F '/' '{ print $NF }'`
CheckEXE0=`which bypy.py`
CheckEXE1=`which ffmpeg`
CheckPS=`ps -e |grep "$CheckEXE"`
if [[ $CheckEXE0 != "" ]]; then
if [[ $CheckEXE1 != "" ]]; then
if [[ $CheckPS == "" ]]; then
WorkDIR="/usr/share/nginx/www"
CreatList;
else
exit 1
fi fi fi
}

function ReadFile()
{
for rDir in `dir .`
do
cDir=$(pwd)
if [[ -d $rDir ]]; then
cd $rDir
ReadFile;
if [[ `dir -d` == "." ]]; then
cd ..
fi
else
CheckDIR=`echo $rDir|awk -F '.' '{ print $NF }' |grep -E "mp4|avi|mkv|mov|wmv|rmvb|rm|flv|zip|7z|rar|iso|exe"`
if [[ $CheckDIR != "" ]]; then
echo "$cDir/$rDir"
mkdir -p /tmp/upload/$cDir
fi fi
done 
}

function CreatList()
{
cd $WorkDIR/download
rm -rf /tmp/upload >/dev/null 2>&1
rm -rf $WorkDIR/list.txt >/dev/null 2>&1
rm -rf $WorkDIR/nolist.txt >/dev/null 2>&1
rm -rf $WorkDIR/Exlist.txt >/dev/null 2>&1
ReadFile > $WorkDIR/list.txt
dir -l $WorkDIR/download |awk "/\.aria2/" |awk '{ print $9 }' |awk -F '.aria2' '{ print $1 }' > $WorkDIR/nolist.txt
python $CheckEXE0 list |awk 'NR!=1{ print $2,$3 }' > $WorkDIR/Exlist.txt
CheckLoad;
}

function CheckLoad()
{
sed -i '/^$/'d $WorkDIR/nolist.txt
NoList=`sed -n 1p $WorkDIR/nolist.txt`
if [[ $NoList != "" ]]; then
sed -i "/$NoList/"d $WorkDIR/list.txt
sed -i "/$NoList/"d $WorkDIR/nolist.txt
CheckLoad;
else
UpLoadFile;
fi
}

function UpLoadFile()
{
sed -i '/^$/'d $WorkDIR/list.txt
UpFile=`sed -n 1p $WorkDIR/list.txt`
if [[ $UpFile != "" ]]; then
Filed=`echo $UpFile |awk -F '.' '{ print $NF }' |grep -E "mp4|avi|mkv|mov|wmv|rmvb|rm|flv"`
if [[ $Filed != "" ]]; then
$CheckEXE1 -y -i "$UpFile" -metadata copyright=Vicer -vcodec copy -acodec copy "/tmp/upload$UpFile"
fi
CheckSize=`du -b "/tmp/upload$UpFile" |awk '{ print $1 }'`
CheckName=`du -b "/tmp/upload$UpFile" |awk '{ print $2 }' |awk -F '/' '{ print $NF }'`
ExSize=`awk "/$CheckName/" $WorkDIR/Exlist.txt |awk '{ print $2 }'`
if [[ $CheckSize == $ExSize ]]; then
sed -i "s#$UpFile#\n#"g $WorkDIR/list.txt
else
python $CheckEXE0 -v upload "/tmp/upload$UpFile"
sed -i "s#$UpFile#\n#"g $WorkDIR/list.txt
fi
rm -rf "/tmp/upload$UpFile" >/dev/null 2>&1
UpLoadFile;
else
rm -rf /tmp/upload >/dev/null 2>&1
rm -rf $WorkDIR/list.txt >/dev/null 2>&1
rm -rf $WorkDIR/nolist.txt >/dev/null 2>&1
rm -rf $WorkDIR/Exlist.txt >/dev/null 2>&1
exit 1
fi
}

Hello;
