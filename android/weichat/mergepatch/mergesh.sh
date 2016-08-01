#! /bin/bash

if [ $# -ne 1 ];then
  echo "please input a filename param "
  exit 1
fi

#operate temp file
cp $1 "temp-"$1

rows=0 # current row number
drns=0 # del row number start
drne=0 # del end
dasum=0 # the total number of delete "+" rows when file just changed

# flag info
fdst=0
fast=0

cat "temp-"$1 | while read line
do
  charo=${line:0:1}
  chart=${line:1:1}

  if [ "$charo" == "-" -a "$chart" != "-" ];then
     rows=`expr $rows + 1` 
     if [ $fdst -eq 0 ];then
        drns=`expr $rows - $dasum`
        fdst=1
	fast=0
     fi

  elif [ "$charo" == "+" -a "$chart" != "+" ];then
     rows=`expr $rows + 1`
     if [ $fast -eq 0 ];then
        drne=`expr $rows - 1 - $dasum`
        fast=1
     fi
  
     if [ $fdst -eq 1 -a $fast -eq 1 ];then
        
        length=${#line}

        if [ $length -gt 41 ];then
	  fstr=${line:1:($length-41)}
	  kstr=${line:0-40}
          result=`sed -n "${drns},${drne}p" $1 | grep -n "$fstr"` # get row number
	  if [ -n "$result" ];then
	    getrn=`expr $drns + ${result:0:1} - 1`
	    rdrn=`expr $rows - $dasum`  # real row number for delete

	    sed -i ''"$getrn"'{s/^-/!/};'"$getrn"'{s/$/&'" $kstr"'/};'"${rdrn}"'d' $1	    	    
	    #sed -i -e "${rdrn}d" $1

	    dasum=`expr $dasum + 1`
	  fi
	fi       
     fi

  else  # ${line:0,1} == ' ' or others
     rows=`expr $rows + 1`
     fdst=0
     fast=0
  fi 
done

#del temp file
rm "temp-"$1
