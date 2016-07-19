#!/bin/bash

# this shell script is to auto get tree for directory

if [ $# -eq 2 ];then

  if [ -d $1 ];then     
     tree $1 > treefor"$1".txt
     if [ $? -eq 0 ];then
        echo "tree for '$1' created successful."
     else
        echo "tree for '$1' created failed."
        exit 1
     fi
  else
    echo "directory $1 is not existed"
    exit 1
  fi
	
  if [ -d $2 ];then
     tree $2 > treefor"$2".txt
     if [ $? -eq 0 ];then
        echo "tree for '$2' created successful."
     else
        echo "tree for '$2' created failed."
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

if [ $? -eq 0 ];then
   diff -Nur treefor"$1".txt treefor"$2".txt > treefor-cmp.patch
   echo "diff file treefor-cmp.patch created successful."

   echo "signkey for android4.2-ramdisk.img: "
   md5sum  android4.2/android-4.2-test/ramdisk.img 
   echo "signkey for android4.3-ramdisk.img: "
   md5sum  android4.3/android-4.3-test/ramdisk.img
else
  echo "file not existed!"
fi

echo "\n"
echo "create file list:"
pwd 
ls -l | grep "treefor*"
