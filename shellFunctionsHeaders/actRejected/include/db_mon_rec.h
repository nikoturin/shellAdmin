#!/bin/bash

###################################################
#Name Process: db_mon_rec.h
#Autor: Ramses Hernandez
#Company:NikOzy
#Date dd/mm/aaaa: 10/02/2015
#Objective: Check  Rejected
#this process check every 30 minutes per hours.
#Msg: If you have a better idea let us know please
###################################################

function add_record()
{
	qpath=$1;

        count=0;
        qdate=$(echo  `date +%Y-%m-%d" "%H:%M:%S`)
        max=$(./ctc_db ctc_db_queues "select max(id) from monit_queues");
        if [[ -z "$max" ]]
          then
                let max=1;
          else
                let max=max+1;
        fi
        while read lqueue
        do
                psr=$(echo "$lqueue" | awk '{print $1}' FS=' ');qname=$(echo "$lqueue" | awk '{print $2}' FS=' ');totname=$(echo "$lqueue" | awk '{print $5}' FS=' ');hostname=$(echo "$lqueue" | awk '{print $7}' FS=' ');

                ./ctc_db ctc_db_queues "insert into monit_queues values($max,'$psr','$qname',$totname,'$hostname','$qdate',0);"
                let max=max+1;
        done < $qpath
}
function add_record_reject()
{
	local strRRecord=$1;

        qdate=$(echo  `date +%Y-%m-%d" "%H:%M:%S`)
        max=$(~/citec/tools/actRejected/bin/ctc_db ~/citec/tools/actRejected/db/ctc_db_act_reject "select max(id) from monit_act_reject");
        if [[ -z "$max" ]]
          then
                let max=1;
          else
                let max=max+1;
        fi
	for str in $(echo "$strRRecord" | tr "|" "\n")
        do
                 rej_statusCode=$(echo "$str" | awk '{print $1}' FS='-')
                 rej_percent=$(echo "$str" | awk '{print $2}' FS='-')
                 rej_total=$(echo "$str" | awk '{print $3}' FS='-'|awk '{print $1}' FS=':')

                ~/citec/tools/actRejected/bin/ctc_db ~/citec/tools/actRejected/db/ctc_db_act_reject "insert into monit_act_reject values($max,'$rej_statusCode','$rej_percent',$rej_total,'$qdate',0);"
                let max=max+1;
        done
}
