#!/bin/bash

file=$1
idBatch=$2

toReplaceId=$( cat $file | tail -n1 | cut -d "'" -f2)

sed -i "s/$toReplaceId/$idBatch/g" $file

while read -r line
do
	#echo "path:" $line

	idRs=$(aws redshift-data execute-statement --profile <account> --region us-east-1 --secret <arn> --cluster-identifier <cluster name> --sql "$line"  --database <DB Name> | jq ".Id" | sed -e 's/"//' -e 's/"//')

	tot=$(aws redshift-data get-statement-result --profile <account> --id  $idRs | jq ".Records[][].longValue" );
	
	tbl=$(echo $line | cut -d " " -f4);
	echo "TBL NAME: $tbl TOTAL: $tot"

done < $file
