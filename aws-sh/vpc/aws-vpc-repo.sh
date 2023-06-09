#!/bin/bash

 echo "Start Report Process Subnets"

 # CSV Header Report
 echo 'OwnerId, VpcId, SubnetId, AvailableIpAddressCount, AvailabilityZone, AvailabilityZoneId, State' > aws-subnet-report.csv

 awsTEnv=$(jq ".| length" accounts.json)
 awsCEnv=0

 #Loop Per environment
 while [ $awsCEnv -lt $awsTEnv ]
 do
 	awsEnv=$(jq -r "to_entries[$awsCEnv] | [.key] | .[]" accounts.json)
	totRegion=$(jq -r ".$awsEnv | length" accounts.json)
	awsCRegion=0
	echo "Env:$awsEnv $awsCRegion ::: $totRegion"
	#Region Loop per environment
	while [ $awsCRegion -lt $totRegion ]
	do
		awsTRegion=$(jq -r ".$awsEnv[$awsCRegion].region | length" accounts.json)
		awsAccount=$(jq -r ".$awsEnv[$awsCRegion].account" accounts.json)
		awsCTRegion=0		
		echo "Region: $awsTRegion Account: $awsAccount"
		# Filter Environment + Account + Region
		while [ $awsCTRegion -lt $awsTRegion ]
		do
			awsNRegion=$(jq -r ".$awsEnv[$awsCRegion].region[$awsCTRegion]" accounts.json)
			echo "Region Name:$awsNRegion"
			awsCTRegion=$((awsCTRegion+1))	
	 		aws ec2 describe-subnets --region $awsNRegion --profile $awsAccount | jq '.Subnets | [.[] | {OwnerId: .OwnerId, VpcId: .VpcId, SubnetId: .SubnetId, AvailableIpAddressCount: .AvailableIpAddressCount, AvailabilityZone: .AvailabilityZone, AvailabilityZoneId: .AvailabilityZoneId, State: .State} ] ' > outputToCsv.txt
	 		jq -r '(.[] | [.OwnerId, .VpcId, .SubnetId, .AvailableIpAddressCount, .AvailabilityZone, .AvailabilityZoneId, .State]) | @csv' outputToCsv.txt >> aws-subnet-report.csv
		done
		#Increment Region Count
		awsCRegion=$((awsCRegion+1))
	done
		#Increment Environment Count
	awsCEnv=$((awsCEnv+1))
 done

 echo "Finish Report Subnets"