#!/bin/bash
###################################################
#Name Process: ctc_aviator_match_fly.sh
#Autor: Ramses Hernandez
#Company:NikOzy
#Date dd/mm/aaaa: 13/07/2012
#Objective: Compare data between Seats DataBase and
#Seats Files Aviator
#Msg: If you have a better idea let us know please
###################################################

source $XXXXX/prfl-env

#Parameters
gl_flight_no=$1
gl_aviator_flight=$2
gl_ICAO=$3
empty=3

#Define to case
def_departure=0
def_arrival=1
def_class=2
def_seats=3

#Interval to get info
ini_dep=5
tot_dep=3
ini_class=3
tot_class=1
ini_seats=4
tot_seats=3
ini_day=7
tot_day=2
ini_month=5
tot_month=2
ini_year=1
tot_year=4

#Flag true and false
TRUE=1
FALSE=0

function aviator_length()
{
  for longDate in $(grep $gl_flight_no $gl_aviator_flight |cut -f 1 -d " ")
  do
	long=`expr length $longDate`
        echo $long
  done  
}

function aviator_queryComp()
{
 lc_flightNo=$1
 lc_flightDate=$2
 lc_flightDepa=$3
 lc_flightArr=$4
 lc_selling=''
 #lc_keyOpen="("
 #lc_keyClose=")"

 declare -a lc_arrClass=("${!5}")
 declare -a lc_arrSeats=("${!6}")

 day=`expr substr $lc_flightDate $ini_day $tot_day`
 month=`expr substr $lc_flightDate $ini_month $tot_month`
 year=`expr substr $lc_flightDate $ini_year $tot_year`
 
 #echo ${#lc_arrClass[@]}"::"${#lc_arrSeats[@]}

 query="set isolation dirty read;

	select x.xxxx,x.xxxx,xxxxx,xxxxx, x.* xxxxxx A
	where xxxxx = '$gl_ICAO$lc_flightNo'
	and xxxxx     = '$month/$day/$year'
	and xxxxx  = '$lc_flightDepa'
	and xxxxx    = '$lc_flightArr'"

 lc_cntSeparate=`expr ${#lc_arrClass[@]} - 1`
 
 for ((j=0; j<${#lc_arrClass[@]}; j++))
 do
   if [ $j -lt $lc_cntSeparate ]
    then
       lc_selling=${lc_selling}"'"${lc_arrClass[$j]}"',"
    else
       lc_selling=${lc_selling}"'"${lc_arrClass[$j]}"'"
   fi
 done

 query=${query}" and selling_cls_code in ("$lc_selling");"
 #echo $query
 echo $query | sqlcmd -F CSV -d $DBNAME > /tmp/TEST_AVIATOR/$gl_flight_no$year$month$day.csv 
 cnt_arrSeats=0
 
 for dataSeats in $(cat /tmp/TEST_AVIATOR/$gl_flight_no$year$month$day.csv | cut -f 1 -d ",")
 do 
     if [[ $dataSeats -eq $(echo ${lc_arrSeats[$cnt_arrSeats]}|bc) ]]
      then
         echo -e "\033[32m$day/$month/$year\t\t$gl_ICAO$lc_flightNo\t\t\tOk\t\t$dataSeats\t\t${lc_arrSeats[$cnt_arrSeats]}\t\t\t${lc_arrClass[$cnt_arrSeats]}"
      else
         echo -e "\033[31m$day/$month/$year\t\t$gl_ICAO$lc_flightNo\t\t\tNot Match\t$dataSeats\t\t${lc_arrSeats[$cnt_arrSeats]}\t\t\t${lc_arrClass[$cnt_arrSeats]}"
     fi
     cnt_arrSeats=$((cnt_arrSeats + 1))
 done 
 rm -rf $gl_flight_no$year$month$day.csv
}

function aviator_date()
{
  declare -a arrDflight
  declare -a arrDeparture
  declare -a arrArrival
  declare -a arrClass
  declare -a arrSeats
  lc_flagSeq=3

  echo -e "\033[33m>------------------------------------------------------------------------------------------------------------------<"
  echo -e "\033[33m>------------------------------------------AVIATOR DATA MATCH------------------------------------------------------<"	
  echo -e "\033[33m--------------------------------------------------------------------------------------------------------------------"
  echo -e "\033[33m Date(d/m/y)\t|\tFlight No.\t|\tStatus\t|\tSeatDB\t|\tSeatAviator\t|\tClass\t|"
  echo -e "\033[33m--------------------------------------------------------------------------------------------------------------------"
  for getDate in $(grep $gl_flight_no $gl_aviator_flight|cut -f 1 -d " " |sort |uniq)
  do
	date=`expr substr $getDate 9 8`
        i=0
	cnt_seq=0
	cnt_departure=0
	cnt_arrival=0
	cnt_class=0
	cnt_seats=0
        
        for getDataLine in $(grep $gl_flight_no $gl_aviator_flight| grep $date$gl_ICAO|sort|tr "  " "-" |sed -e "s/--/-/g"|sed -e "s/-/ /g"|cut -f 2-5 -d " ")
        do
            case $cnt_seq in
            	$def_departure)
			getDeparture=`expr substr $getDataLine $ini_dep $tot_dep`
		   	#echo $cnt_seq"-"$cnt_departure"-"$getDeparture
			arrDeparture[$cnt_departure]=$getDeparture
			cnt_departure=$(($cnt_departure+1));;
		$def_arrival)
			getArrival=`expr substr $getDataLine 1 3`
			arrArrival[$cnt_arrival]=$getArrival
			#echo $cnt_seq"-"$cnt_arrival"-"$getArrival"-"${arrArrival[@]:$cnt_arrival}
			cnt_arrival=$((cnt_arrival+1));;
		$def_class)
			getClass=`expr substr $getDataLine $ini_class $tot_class`
			#echo $cnt_seq"-"$cnt_class"-"$getClass
			arrClass[$cnt_class]=$getClass
			cnt_class=$((cnt_class+1));;
		$def_seats)
			getSeats=`expr substr $getDataLine $ini_seats $tot_seats`                        
			#echo $cnt_seq"-"$cnt_seats"-"$getSeats
			arrSeats[$cnt_seats]=$getSeats                        
			cnt_seats=$((cnt_seats+1));;
	    esac
	    if [ $cnt_seq = $lc_flagSeq  ]
	    then
		cnt_seq=$((cnt_seq-cnt_seq))
	    else 
	    	cnt_seq=$((cnt_seq+1))
            fi
	    
        done
        
	aviator_queryComp $gl_flight_no $date ${arrDeparture[@]:0:1} ${arrArrival[@]:0:1} arrClass[@] arrSeats[@]
	
	#I can't find any better method to do this, really i don't like
        for idPos in $(seq 0 $((cnt_class-1)))
 	do	
	   unset arrDeparture[$idPos]
	   unset arrArrival[$idPos]
	   unset arrClass[$idPos]
	   unset arrSeats[$idPos]
        done
  done
  echo -e "\033[33m--------------------------------------------------------------------------------------------------------------------"
  echo -e "\033[0m" 
}

if test $# -lt $empty
then
    "Usage: ./ctc_aviator_match_fly.sh <Flight No> <File Aviator> <ICAO CODE>"
    exit 1
else
    aviator_date
fi
