#!/bin/bash

###################################################
#Name Process: ctc_check_act_rejected.sh
#Autor: Ramses Hernandez
#Company:NikOzy
#Date dd/mm/aaaa: 10/02/2015
#Objective: Check Rejected
#this process check every 30 minutes per hours.
#Msg: If you have a better idea let us know please
###################################################

source $RESULTS/prfl-env
source ~/citec/tools/actRejected/include/ctc_qry_ifx.h
source ~/citec/tools/actRejected/include/ctc_utils.h
source ~/citec/tools/actRejected/include/ctc_DOM.h
source ~/citec/tools/actRejected/include/db_mon_rec.h

date=$(echo  `date +%Y-%m-%d" "%H:%M:%S`)
actDate=$(stat_actuallyDate);
actDT=$(stat_getDT $actDate);
actDTLess=$(stat_getDTLess $actDate);
threshold="20.00";
thresholdRej="20";

#|ACCEPT|2013-08-26:04|1|

strReject=$((echo "select
		result_code, 
		TO_CHAR(request_date_time, '%Y-%m-%d:%H'), 
		count(*) 
		from accertify_transaction
	        where request_date_time between '$actDTLess' and '$actDT'
		group by 1,2 
		order by 1,2" | sqlcmd -d $RRTDBNAME )  | while read str 
do
	echo "|"$str"|";
done);

totRJST=$(for rec in $(echo "$strReject" )
do 
      statusCode=$(echo "$rec" | awk '{print $2}' FS='|')
      countReject=$(echo "$rec" | awk '{print $4}' FS='|')
      
      if [[ -n "$statusCode" ]]
       then
        if [[ "$statusCode" = "REJECT" ]]
          then
                let totalReject=totalReject+countReject;
	elif [[ "$statusCode" = "REVIEW" ]]
	  then
		let totalReview=totalReview+countReject;
	else
                let totalAccept=totalAccept+countReject;
	fi
      fi
      let totStatus=totStatus+countReject;
done
	if [[ -z "$totalReject" ]]
	 then 
		totalReject=0;
	fi
        if [[ -z "$totalReview" ]]
         then 
                totalReview=0;
        fi
        if [[ -z "$totalAccept" ]]
         then 
                totalAccept=0;
        fi
	percentReject=$(echo "scale=2; ($totalReject/$totStatus)*100" |bc);
	percentReview=$(echo "scale=2; ($totalReview/$totStatus)*100" |bc);
	percentAccept=$(echo "scale=2; ($totalAccept/$totStatus)*100" |bc);

	echo "REJECT-$percentReject-$totalReject|REVIEW-$percentReview-$totalReview|ACCEPT-$percentAccept-$totalAccept:TOTAL-$totStatus"
);

      perc=$(echo "$totRJST" | awk '{print $1}' FS='|' | awk '{print $2}' FS='-');
      totCheck=$(echo "$totRJST" | cut -f8 -d'-');
      if [[ -n "$perc" ]]
       then
        if [[ "$(echo $perc '>=' $threshold | bc -l)" = 1 ]] && [[ "$(echo $totCheck '>=' $thresholdRej | bc -l)" = 1 ]]
         then 
                csv=$(rej_ifx_toFile "$actDTLess" "$actDT");
                dom_sendEmail "$totRJST" "$csv"
		add_record_reject "$totRJST"
        fi
      fi

echo $totRJST >> ~/citec/tools/actRejected/log/act_reject.log
