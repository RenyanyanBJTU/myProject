#!/bin/bash

# this shell script is to auto mount and get info about files in android.raw 

#install software
sudo apt-get install tree kpartx

#mount android-4.2.raw
sudo losetup /dev/loop0 android-4.2.raw
sudo kpartx -av /dev/loop0
sudo mount /dev/mapper/loop0p1 /mnt/android4.2
if [ $? -ne 0 ];then
  echo "mount android4.2 faild.program running stoped."
  exit 1
else
  echo "mount android4.2 successful."
fi

#mount android-4.3.raw
sudo losetup /dev/loop1 android-4.3.raw
sudo kpartx -av /dev/loop1
sudo mount /dev/mapper/loop1p1 /mnt/android4.3
if [ $? -ne 0 ];then
  echo "mount android4.3 faild.program running stoped."
  exit 1
else
  echo "mount android4.3 successful."
fi

# copy file form /mnt to current dir
echo "copy /mnt/.. to current dir...."
sudo cp -R /mnt/android4.2/. android4.2
sudo cp -R /mnt/android4.3/. android4.3
if [ $? -ne 0 ];then
  echo "copy faild.program running stoped."
  exit 1
else
  echo "copy successful."
fi

#release mount source
sudo umount /mnt/android4.2
sudo kpartx -dv /dev/loop0
sudo losetup -d /dev/loop0
sudo umount /mnt/android4.3
sudo kpartx -dv /dev/loop1
sudo losetup -d /dev/loop1
if [ $? -ne 0 ];then
  echo "release loop faild.program running stoped."
  exit 1
else
  echo "release loop successful."
fi

#get android4.2 file system
cd android4.2/android-4.2-test/
sudo mkdir ramdisk
sudo cp ramdisk.img ramdisk/
cd ramdisk
sudo mv ramdisk.img ramdisk.img.gz
sudo gunzip ramdisk.img.gz 
sudo cpio -i -F ramdisk.img
if [ $? -ne 0 ];then
  echo "get android4.2 ramdisk faild.program running stoped."
  exit 1
else
 echo "get android4.2 ramdisk successful."
fi

#get android4.3 file system
cd ../../..
cd android4.3/android-4.3-test/
sudo mkdir ramdisk
sudo cp ramdisk.img ramdisk/
cd ramdisk
sudo mv ramdisk.img ramdisk.img.gz
sudo gunzip ramdisk.img.gz
sudo cpio -i -F ramdisk.img
if [ $? -ne 0 ];then
  echo "get android4.3 ramdisk faild. program running stoped."
  exit 1
else
 echo "get android4.3 ramdisk successful."
fi

#get source tree
cd ../../..
sudo sh treesh.sh android4.2 android4.3
if [ $? -ne 0 ];then
  echo "treesh.sh program running stoped."
  exit 1
else
 echo "treesh.sh program running successful."
fi










