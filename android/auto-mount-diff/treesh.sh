#!/bin/bash

# this shell script is to auto get tree for directory

if [ $# -eq 2 ];then

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
	
  if [ -d $2 ];then
     tree $2 > treefor"$2".txt
     tree -i -f $2 > ftreefor"$2".txt
     if [ $? -eq 0 ];then
        echo "tree for $2 created successful."
     else
        echo "tree for $2 created failed."
        exit 1
     fi
  else
    echo "directory $2 is not existed"
    exit 1
  fi
else
  echo "must input two directory" 
  exit 1
fi

#get singkey
echo "update signkey info,wait a few mimutes......"
sh signkeysh.sh treefor"$1".txt
if [ $? -ne 0 ];then
  echo "treefor$1.txt update signkey failed.progress running stoped."
  exit 1
else
 echo "treefor$1.txt update signkey successful."
fi

sh signkeysh.sh treefor"$2".txt

if [ $? -ne 0 ];then
  echo "treefor$2.txt update signkey failed.progress running stoped."
  exit 1
else
 echo "treefor$2.txt update signkey successful."
fi


if [ $? -eq 0 ];then
   diff -Nur treefor"$1".txt treefor"$2".txt > treefor-cmp.patch
   echo "diff file treefor-cmp.patch created successful."
else
  echo "file not existed!"
fi

