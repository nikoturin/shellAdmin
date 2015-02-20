#!/bin/bash
###################################################
#Name Process: ctc_watchdog.sh
#Autor: Ramses Hernandez
#Company:NikOzy
#Date dd/mm/aaaa: 11/11/2013
#Objective: Check if the process on srv2 are
#still running
#Msg: If you have a better idea let us know please
###################################################
                        
dateTime=$(date +%m%d%y);
#dateTime="110713";              
declare -a dateTimeFail         
services=('AdHocService' 'avail_service' 'rvavlbty' 'rvfarclc');
remoteHost="rrtvivbe02";
                                
function wt_tuxedoUp()  
{                               
                                
        for (( u=0; u<${#services[@]}; u++ ))
        do                              
                                        
                echo "tmboot -y -s "${services[$u]}" -l "$remoteHost"" >> fileTux.txt
                                                
        done                            
                                
}                               
function wt_chargeData()        
{                                 
  local let idx=0;                     
  local global=0;                      
                                       
        for dates in $(awk '/BBL broadcast reply timeout/{i=1; split($0,a,".");{ print a[1]}};'  ULOG.$dateTime)
        do                             
                let global++;   
                        
                #echo "start:$idx" $dates
                if [[ ! -z $dates ]]
                  then
                        if [[ ${#dateTimeFail[@]} -eq 0 ]]
                          then
                                dateTimeFail[$idx]=$dates;
                                #echo "NULL:" $dates;
                                echo "txmlCLIENTESOTE:" $dates;
                                wt_tuxedoUp
                                let idx++;
                        else
                                let flagCharge=0;
                                for (( j=0; j<${#dateTimeFail[@]}; j++ ))
                                do
                                        echo $j".-"${dateTimeFail[$j]}"vs"$dates
                                        if [[ "${dateTimeFail[$j]}" == "$dates" ]]
                                          then
                                                let flagCharge++;
                                        fi
                                done
                                echo ${#dateTimeFail[@]} "vs" $flagCharge "idx" $idx;
                                if [[ $flagCharge -eq 0 ]]
                                  then
                                       echo "txmlCLIENTESOTE:" $dates;
                                       wt_tuxedoUp
                                       let idx=${#dateTimeFail[@]};
                                       dateTimeFail[$idx]=$dates;
                                       let idx++;
                                fi
                        fi
                fi
        done
}
while true
do
        wt_chargeData
done
