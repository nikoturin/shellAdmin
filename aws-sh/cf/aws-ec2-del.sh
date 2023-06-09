#!/bin/bash

CFSTACKNAME="STACK-NAME";

redStatus=$(aws cloudformation list-stacks | jq -r '.StackSummaries[] | select (.StackName == "'$CFSTACKNAME'" and (.StackStatus == "CREATE_FAILED" or .StackStatus == "DELETE_FAILED" or .StackStatus == "ROLLBACK_FAILED" or .StackStatus == "UPDATE_FAILED" or .StackStatus == "UPDATE_ROLLBACK_FAILED")) | .StackStatus');
if [ -z $redStatus ];
    then 
        aws cloudformation delete-stack --stack-name $CFSTACKNAME;
    else 
        echo "CHECK WITH ADMIN: $redStatus";
fi

echo "START TO CHECK STATUS DELETE TO STACK: $CFSTACKNAME";

while true
do
	delStatus=$(aws cloudformation list-stacks | jq -r '.StackSummaries[] | select (.StackName == "'$CFSTACKNAME'" and (.StackStatus == "DELETE_IN_PROGRESS")) | .StackStatus')

    if [ -z $delStatus ];
        then    
            echo "DELETE IS DONE TO STACK: $CFSTACKNAME"
            break
    else
        echo "CHECKING STACK $CFSTACKNAME STATUS:$delStatus CONTINUE ..."
    fi

    sleep 5
done
