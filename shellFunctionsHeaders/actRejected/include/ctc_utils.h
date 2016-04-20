#!/bin/bash

###################################################
#Name Process: ctc_utils.h
#Autor: Ramses Hernandez
#Company:NikOzy
#Date dd/mm/aaaa: 10/02/2015
#Objective: Check Rejected
#this process check every 30 minutes per hours.
#Msg: If you have a better idea let us know please
###################################################

function stat_actuallyDate()
{ 
	#ACTUALLYDATE=$(date -d "$(date +%Y-%m-%d)" "+%s"); 
	ACTUALLYDATE=$(date +%s); 
	echo $ACTUALLYDATE;
}
function stat_getDT()
{
        local epoch=$1;
        #echo "stat_getDate $1"; #GTM -6  
        epoch=$((epoch-21600));
       
        CONVER_EPOCH=$(date --date "1970-01-01 $epoch sec" "+%Y-%m-%d %H:%M:%S");
        echo $CONVER_EPOCH;
}
function stat_getDTLess()
{ 
	local epoch=$1;
	local epochLess=0; 
	#echo "stat_getDate $1"; #GTM -6  
 	epoch=$((epoch-21600));
	epochLess=$((epoch-1800));
 	CONVER_EPOCH=$(date --date "1970-01-01 $epochLess sec" "+%Y-%m-%d %H:%M:%S");
 	echo $CONVER_EPOCH;
}
