#!/bin/bash

# this shell script is to auto get tree with signkey for directory

if [ $# -eq 1 ];then

  if [ -d $1 ];then     
     tree $1 > treefor"$1".txt
     tree -i -f $1 > ftreefor"$1".txt
     if [ $? -eq 0 ];then
        echo "tree for $1 created successful."
     else
        echo "tree for $1 created failed."
        exit 1
     fi
  else
    echo "directory $1 is not existed"
    exit 1
  fi
	
else
  echo "must input a directory name" 
  exit 1
fi

#get singkey
echo "update treefor$1.txt signkey info,wait a few mimutes......"

sudo chmod 664 treefor"$1".txt

rown=1 # row number
cat ftreefor"$1".txt |tr -s '\n' | while read line
do
  line=`echo $line | cut -d ' ' -f 1`
  if [ -f $line ];then
   # signkey=`sudo md5sum $line | cut -d ' ' -f 1`
    signkey=`sudo sha1sum $line | cut -d ' ' -f 1`
    sed -i ''"$rown"'{s/$/&'" $signkey"'/g}' treefor"$1".txt
  fi
   rown=`expr $rown + 1`
done

if [ $? -ne 0 ];then
  echo "treefor$1.txt update signkey failed.progress running stoped."
  exit 1
else
 echo "treefor$1.txt update signkey successful."
fi


