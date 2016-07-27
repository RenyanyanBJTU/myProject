#!/bin/bash

# this shell script is to auto mount and get info 
#about files in android installed disk(format qcow2 or raw) 

if [ $# -ne 2 ];then
  echo "please input two android installed disk name"
  exit 1
fi

#install software
sudo apt-get install tree kpartx


#mount android-old and get source folder
sudo mkdir /mnt/android-old

sudo losetup /dev/loop0 $1
sudo kpartx -av /dev/loop0
sudo mount /dev/mapper/loop0p1 /mnt/android-old

if [ $? -ne 0 ];then
  echo "changing mount method......"
  sudo kpartx -dv /dev/loop0
  sudo losetup -d /dev/loop0

  sudo modprobe nbd max_part=8

  sudo qemu-nbd -c /dev/nbd0 $1
  sudo mount /dev/nbd0p1 /mnt/android-old
  
  if [ $? -ne 0 ];then
    echo "mount android-old faild.program running stoped."
    exit 1
  else
    echo "mount android-old successful."
  fi
   
  # copy file form /mnt to current dir
  echo "copy /mnt/android-old to current dir...."
  sudo cp -R /mnt/android-old/. android-old
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
 
  #release source
  sudo umount /mnt/android-old
  sudo killall qemu-nbd ##
  if [ $? -ne 0 ];then
    echo "release qemu-nbd faild.program running stoped."
    exit 1
  else
    echo "release qemu-nbd successful."
  fi

else
  echo "mount android-old successful."
 
  # copy file form /mnt to current dir
  echo "copy /mnt/android-old to current dir...."
  sudo cp -R /mnt/android-old/. android-old
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
  
  #release mount source
  sudo umount /mnt/android-old
  sudo kpartx -dv /dev/loop0
  sudo losetup -d /dev/loop0

  if [ $? -ne 0 ];then
    echo "release loop faild.program running stoped."
    exit 1
  else
    echo "release loop successful."
  fi
fi


#mount android-new and get source folder
sudo mkdir /mnt/android-new

sudo losetup /dev/loop0 $2
sudo kpartx -av /dev/loop0
sudo mount /dev/mapper/loop0p1 /mnt/android-new

if [ $? -ne 0 ];then
  echo "changing mount method......"
  sudo kpartx -dv /dev/loop0
  sudo losetup -d /dev/loop0

  sudo modprobe nbd max_part=8

  sudo qemu-nbd -c /dev/nbd0 $2
  sudo mount /dev/nbd0p1 /mnt/android-new
  
  if [ $? -ne 0 ];then
    echo "mount android-new faild.program running stoped."
    exit 1
  else
    echo "mount android-new successful."
  fi
   
  # copy file form /mnt to current dir
  echo "copy /mnt/android-new to current dir...."
  sudo cp -R /mnt/android-new/. android-new
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
 
  #release source
  sudo umount /mnt/android-new
  sudo killall qemu-nbd ##
  if [ $? -ne 0 ];then
    echo "release qemu-nbd faild.program running stoped."
    exit 1
  else
    echo "release qemu-nbd successful."
  fi

else
  echo "mount android-new successful."
 
  # copy file form /mnt to current dir
  echo "copy /mnt/android-new to current dir...."
  sudo cp -R /mnt/android-new/. android-new
  if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
  else
    echo "copy successful."
  fi
  
  #release mount source
  sudo umount /mnt/android-new
  sudo kpartx -dv /dev/loop0
  sudo losetup -d /dev/loop0

  if [ $? -ne 0 ];then
    echo "release loop faild.program running stoped."
    exit 1
  else
    echo "release loop successful."
  fi
fi

#get android-old file system
cd android-old/android-2016-07-23/
sudo mkdir ramdisk
sudo cp ramdisk.img ramdisk/
cd ramdisk
sudo mv ramdisk.img ramdisk.img.gz
sudo gunzip ramdisk.img.gz 
sudo cpio -i -F ramdisk.img
if [ $? -ne 0 ];then
  echo "get android-old ramdisk faild.program running stoped."
  exit 1
else
 echo "get android-old ramdisk successful."
fi

#get android-new file system
cd ../../..
cd android-new/android-2016-07-23/
sudo mkdir ramdisk
sudo cp ramdisk.img ramdisk/
cd ramdisk
sudo mv ramdisk.img ramdisk.img.gz
sudo gunzip ramdisk.img.gz
sudo cpio -i -F ramdisk.img
if [ $? -ne 0 ];then
  echo "get android-new ramdisk faild. program running stoped."
  exit 1
else
 echo "get android-new ramdisk successful."
fi

#get source tree
cd ../../..
sudo sh treesh.sh android-old android-new
if [ $? -ne 0 ];then
  echo "treesh.sh program running stoped."
  exit 1
else
 echo "treesh.sh program running successful."
fi

