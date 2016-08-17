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

  if [ x"$charo" == x"-" -a x"$chart" != x"-" ];then
     rows=`expr $rows + 1` 
     
     if [ $fdst -eq 0 ];then
        drns=`expr $rows - $dasum`
        #drns=$rows
        fdst=1
        fast=0
     fi

  elif [ x"$charo" == x"+" -a x"$chart" != x"+" ];then
     rows=`expr $rows + 1`
     if [ $fast -eq 0 ];then  #the end of del row+1
        drne=`expr $rows - 1 - $dasum`
        #drne=`expr $rows - 1`
        fast=1
     fi
  
     if [ $fdst -eq 1 -a $fast -eq 1 ];then
    
     	line=${line:1} #get string after first char                           
	
		fstr=`echo $line | cut -d ' ' -f1` #filename string 
		kstr=`echo $line | cut -d ' ' -f2` #signkey string

		result=`sed -n "${drns},${drne}p" $1 | grep -n -w "$fstr"` # get row number
	  	if [ -n "$result" ];then
	       getrn=`expr $drns + ${result%%':'*} - 1`
	       rdrn=`expr $rows - $dasum`  # real row number for delete

		   result=${result#*':'}  
		   result=${result:1} # full string of filename and signkey


		   rfstr=`echo $result | cut -d ' ' -f1`  #result filename string
		   rkstr=`echo $result | cut -d ' ' -f2`  #result signkey string
	   
		   if [ "$fstr" == "$rfstr" -a "$rkstr" != "directories," ];then 

		      if [ x"$kstr" != x"$rkstr" ];then #change case
				sed -i ''"$getrn"'{s/^-/!/};'"$getrn"'{s/$/&'" $kstr"'/};'"${rdrn}"'d' $1
		      else #no change
				sed -i ''"$getrn"'{s/^-/ /};'"${rdrn}"'d' $1
		      fi					
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

