#!/bin/bash

sudo chmod 664 treeforandroid4.2.txt
sudo chmod 664 treeforandroid4.3.txt

if [ $# -ne 1 ];then
  echo "please input filename."
  exit 1
fi

rown=1 # row number
cat "f"$1 |tr -s '\n' | while read line
do
  line=`echo $line | cut -d ' ' -f 1`
  if [ -f $line ];then
    signkey=`sudo md5sum $line | cut -d ' ' -f 1`

    sed -i ''"$rown"'{s/$/&'"  $signkey"'/g}' $1

  fi
  
   rown=`expr $rown + 1`

done


