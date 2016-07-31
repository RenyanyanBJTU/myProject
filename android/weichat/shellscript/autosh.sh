#!/bin/bash

if [ $# -ne 2 ];then
  echo "please input two android installed disk name"
  exit 1
else 
  if [ -f $1 -a -f $2 ];then
    echo "find file $1 and $2"
  else
    echo " please input two android installed disk name "
    exit 1
  fi
fi


#install software
echo "detecting necessary software package......"
dpkg -s tree
if [ $? -ne 0 ];then
  sudo apt-get install tree
else
  echo "package tree is already installed."
fi
dpkg -s kpartx
if [ $? -ne 0 ];then
  sudo apt-get install kpartx
else
  echo "package kpartx is already installed."
fi

#get system directory
sudo sh mountgetsh.sh $1
if [ $? -ne 0 ];then
   exit 1
fi

sudo sh mountgetsh.sh $2
if [ $? -ne 0 ];then
   exit 1
fi

#get directory name
var=$1
diro=${var%.*}
var=$2
dirn=${var%.*}

echo "creating source tree ... ..."

#get source tree with signkey
sudo sh treesh.sh $diro
if [ $? -ne 0 ];then
  echo "get source tree for $diro program running stoped."
  exit 1
else
  echo "get source tree for $diro program running successful."
  sudo rm -R $diro
fi

sudo sh treesh.sh $dirn
if [ $? -ne 0 ];then
  echo "get source tree for $dirn program running stoped."
  exit 1
else
  echo "get source tree for $dirn program running successful."
  sudo rm -R $dirn
fi

#get diff between old and new
if [ $? -eq 0 ];then
   diff -Nur treefor"$diro".txt treefor"$dirn".txt > treefor-cmp.patch
   echo "diff file treefor-cmp.patch created successful."
else
  echo "file not existed!"
fi

if [ $? -eq 0 ];then
  echo "all is running successful, program end."
fi

