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
        fdst=1
		fast=0
     fi

  elif [ x"$charo" == x"+" -a x"$chart" != x"+" ];then
     rows=`expr $rows + 1`
     if [ $fast -eq 0 ];then  #the end of del row+1
        drne=`expr $rows - 1 - $dasum`
        fast=1
     fi
  
     if [ $fdst -eq 1 -a $fast -eq 1 ];then
        
        line_left=${line%%'── '*} #get dir grade
        length_ll=${#line_left}
        
        length=${#line}
	line=${line#*'── '} # full string 
	length2=${#line}
		
	if [ "$length" != "$length2" ];then #pai chu wenjian nei bu de tong ji xin xi 
	    	
		fstr=${line%' '*} #filename string
		kstr=${line#*' '} #signkey string

		result=`sed -n "${drns},${drne}p" $1 | grep -n -w "$fstr"` # get row number
	  	if [ -n "$result" ];then
	           getrn=`expr $drns + ${result:0:1} - 1`
	    	   rdrn=`expr $rows - $dasum`  # real row number for delete
				
		   result_left=${result%%'── '*}
		   result_left=${result_left#*':'}
		   length_rl=${#result_left} # get dir grade
				
		   result=${result#*'── '} # full string of filename and signkey
		   rfstr=${result%%' '*}    #result filename string
		   rkstr=${result#*' '}  #result signkey string

		   if [ x"$length_rl" == x"$length_ll" -a x"$fstr" == x"$rfstr" ];then

		      if [ x"$kstr" == x"$rkstr" ];then #no change
			sed -i ''"$getrn"'{s/^-/ /};'"${rdrn}"'d' $1
		      else #change case
			sed -i ''"$getrn"'{s/^-/!/};'"$getrn"'{s/$/&'" $kstr"'/};'"${rdrn}"'d' $1
			
		      fi	
									
		      dasum=`expr $dasum + 1`
		   fi	    			    			    		
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

