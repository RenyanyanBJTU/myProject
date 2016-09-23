#! /bin/bash

if [ $# -ne 1 ];then
  echo "please input a filename"
  exit 1
fi

filename=$1
filename=${filename%.*}

if [ -f s"$filename".patch ];then
  rm s"$filename".patch 
fi

cat $1 | while read line
do
  charo=${line:0:1}

  if [ x"$charo" == x"-" -o x"$charo" == x"+" -o x"$charo" == x"!" ];then
    echo $line >> s"$filename".patch 
    
  elif [ x"$charo" == x"@" ];then
    echo "" >>s"$filename".patch
    echo $line >> s"$filename".patch 

  fi

done 

if [ $? -eq 0 ];then
  echo "s$filename.patch create successful."
fi

