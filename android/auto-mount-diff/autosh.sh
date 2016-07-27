#!/bin/bash

# this shell script is to auto mount and get info 
#about files in android installed disk(format qcow2 or raw) 

if [ $# -ne 2 ];then
  echo "please input two android installed disk name"
  exit 1
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

#mount $1 and get source folder

#get filename to create directory -- use two method
var=$1
diro=${var%.*} 
dirn=$(basename $2 .img)

if [ -d /mnt/$diro ];then 
  echo "/mnt/$diro is already exist."
else
 echo "create $diro directory in /mnt"
 sudo mkdir /mnt/$diro
fi

sudo losetup /dev/loop0 $1
sudo kpartx -av /dev/loop0
sudo mount /dev/mapper/loop0p1 /mnt/$diro

if [ $? -ne 0 ];then
  echo "changing mount method......"
  sudo kpartx -dv /dev/loop0
  sudo losetup -d /dev/loop0

  sudo modprobe nbd max_part=8

  sudo qemu-nbd -c /dev/nbd0 $1
  sudo mount /dev/nbd0p1 /mnt/$diro
  
  if [ $? -ne 0 ];then
    echo "mount $1 faild.program running stoped."
    exit 1
  else
    echo "mount $1 successful."
  fi
   
  # copy file form /mnt to current dir
  echo "copy /mnt/$diro to current dir...."
  sudo cp -R /mnt/$diro/. $diro
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
 
  #release source
  sudo umount /mnt/$diro
  sudo killall qemu-nbd ##
  if [ $? -ne 0 ];then
    echo "release qemu-nbd faild.program running stoped."
    exit 1
  else
    echo "release qemu-nbd successful."
  fi  

else
  echo "mount $1 successful."
 
  # copy file form /mnt to current dir
  echo "copy /mnt/$diro to current dir...."
  sudo cp -R /mnt/$diro/. $diro
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
  
  #release mount source
  sudo umount /mnt/$diro
  sudo kpartx -dv /dev/loop0
  sudo losetup -d /dev/loop0

  if [ $? -ne 0 ];then
    echo "release loop faild.program running stoped."
    exit 1
  else
    echo "release loop successful."
  fi
fi


#mount $2 and get source folder
if [ -d /mnt/$dirn ];then
  echo "/mnt/$dirn is already exist."
else
 echo "create $dirn folder in /mnt"
 sudo mkdir /mnt/$dirn
fi

sudo losetup /dev/loop0 $2
sudo kpartx -av /dev/loop0
sudo mount /dev/mapper/loop0p1 /mnt/$dirn

if [ $? -ne 0 ];then
  echo "changing mount method......"
  sudo kpartx -dv /dev/loop0
  sudo losetup -d /dev/loop0

  sudo modprobe nbd max_part=8

  sudo qemu-nbd -c /dev/nbd0 $2
  sudo mount /dev/nbd0p1 /mnt/$dirn
  
  if [ $? -ne 0 ];then
    echo "mount $2 faild.program running stoped."
    exit 1
  else
    echo "mount $2 successful."
  fi
   
  # copy file form /mnt to current dir
  echo "copy /mnt/$dirn to current dir...."
  sudo cp -R /mnt/$dirn/. $dirn
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
 
  #release source
  sudo umount /mnt/$dirn
  sudo killall qemu-nbd ##
  if [ $? -ne 0 ];then
    echo "release qemu-nbd faild.program running stoped."
    exit 1
  else
    echo "release qemu-nbd successful."
  fi

else
  echo "mount $2 successful."
 
  # copy file form /mnt to current dir
  echo "copy /mnt/$dirn to current dir...."
  sudo cp -R /mnt/$dirn/. $dirn
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
  
  #release mount source
  sudo umount /mnt/$dirn
  sudo kpartx -dv /dev/loop0
  sudo losetup -d /dev/loop0

  if [ $? -ne 0 ];then
    echo "release loop faild.program running stoped."
    exit 1
  else
    echo "release loop successful."
  fi
fi

#delete temp directory in /mnt
sudo rm -R /mnt/$diro
sudo rm -R /mnt/$dirn

#get $1 file system
var=`sudo find $diro/ -name "ramdisk.img" -exec dirname {} \;`
cd $var
sudo mkdir ramdisk
sudo cp ramdisk.img ramdisk/
cd ramdisk
sudo mv ramdisk.img ramdisk.img.gz
sudo gunzip ramdisk.img.gz 
sudo cpio -i -F ramdisk.img
if [ $? -ne 0 ];then
  echo "get $1 ramdisk faild.program running stoped."
  exit 1
else
 echo "get $1 ramdisk successful."
fi
sudo rm ramdisk.img

#get $dirn file system
cd ../../..
var=`sudo find $dirn/ -name "ramdisk.img" -exec dirname {} \;`
cd $var
sudo mkdir ramdisk
sudo cp ramdisk.img ramdisk/
cd ramdisk
sudo mv ramdisk.img ramdisk.img.gz
sudo gunzip ramdisk.img.gz
sudo cpio -i -F ramdisk.img
if [ $? -ne 0 ];then
  echo "get $dirn ramdisk faild. program running stoped."
  exit 1
else
 echo "get $dirn ramdisk successful."
fi
sudo rm ramdisk.img

#get source tree
cd ../../..
sudo sh treesh.sh $diro $dirn
if [ $? -ne 0 ];then
  echo "treesh.sh program running stoped."
  exit 1
else
 echo "treesh.sh program running successful."
fi

