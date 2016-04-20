#!/bin/bash

function rej_ifx_toFile()
{
	local dStart=$1;
	local dEnd=$2;

	outputPNR=$((echo "select
        	xx.xxxx,
        	xx.xxxx,
        	x.xxxxxx,
        	xx.xxxxxx,
        	TO_CHAR(xx.xxxxxxxx, '%Y-%m-%d %H') as date_time
	from xxxxxxxxx as xx
		inner join xxxxx as p on p.xxxxxx_no=xx.xxxxx
	where xxxxxxxxx between '$dStart' and '$dEnd'
		and xx.xxxxx='XXXXX';"|sqlcmd -d $DBNAME -H) |while read str
do
	echo "\n" $str;

done);

echo -e $outputPNR;
}
