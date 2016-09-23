#!/bin/bash

# this shell script is to auto mount and get info 
#about files in android installed disk(format qcow2 or raw) 

if [ $# -ne 1 ];then
  echo "please input a android installed disk name"
  exit 1
else
  if [ -f $1 ];then
    echo "disk name is $1"
  else
    echo "please input a android installed disk name" 
    exit 1
  fi
fi

#mount $1 and get source folder 

var=$1
#dirname=${var%.*}
dirname=${var%'-'*} # get static dir name android


if [ -d /mnt/$dirname ];then 
  echo "/mnt/$dirname is already exist."
else
 echo "create $dirname directory in /mnt"
 sudo mkdir /mnt/$dirname
fi

devname=`losetup -f` # find first unused device
loname=${devname##*/}
echo "find unused device $devname $loname"

sudo losetup $devname $1
sudo kpartx -av $devname
sudo mount /dev/mapper/"$loname"p1 /mnt/$dirname
if [ $? -ne 0 ];then
  echo "changing mount method......"
  #sudo umount /mnt/$dirname
  sudo kpartx -dv $devname
  sudo losetup -d $devname

  sudo modprobe nbd max_part=8

  sudo qemu-nbd -c /dev/nbd0 $1
  sudo mount /dev/nbd0p1 /mnt/$dirname
  
  if [ $? -ne 0 ];then
    echo "mount $1 faild.program running stoped."
    exit 1
  else
    echo "nbd method mount $1 successful."
  fi
   
  # copy file form /mnt to current dir
  echo "copy /mnt/$dirname to current dir...."
  sudo cp -R /mnt/$dirname/. $dirname
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
 
  #release source
  sudo umount /mnt/$dirname
  sudo killall qemu-nbd ##
  if [ $? -ne 0 ];then
    echo "release qemu-nbd for $1 faild.program running stoped."
    exit 1
  else
    echo "release qemu-nbd for $1 successful."
  fi  

else
  echo "kpartx method mount $1 successful."
 
  # copy file form /mnt to current dir
  echo "copy /mnt/$dirname to current dir...."
  sudo cp -R /mnt/$dirname/. android
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
  
  #release mount source
  sudo umount /mnt/$dirname
  sudo kpartx -dv $devname
  sudo losetup -d $devname

  if [ $? -ne 0 ];then
    echo "release loop for $1 faild.program running stoped."
    exit 1
  else
    echo "release loop for $1 successful."
  fi
fi

#delete temp directory in /mnt
sudo rm -R /mnt/$dirname

