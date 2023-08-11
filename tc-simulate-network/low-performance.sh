#!/bin/bash
# This script was created to test bandwith before to install StarkLink
# Is necesary to have 2 VM LAN to LAN Server and Client.
# The objective was to make a choose, between protocol HTTP or MQ

option=$1

echo "Context about the transfer data:"
echo "	- Starklink: 15Mb/s"
echo "	- FleetOne:  32Kb/s"

if [[ "$option" == "MQ" ]]
then
	echo "MQ TESTING PEFORMANCE"
	tc qdisc add dev enp0s8 root tbf rate 1mbit burst 32kbit latency 400ms

	echo "Traffic Control configure:"	
	echo "	- 32kbit upload"
	echo "	- 400ms  latency"
	echo "Parameters executed:"
	tc qdisc show dev enp0s8 root
	#iperf -c <host> f K
else 
	echo "HTTP TESTING PERFORMANCE Actions to Restart Parameters"
	echo "HTTP Deleting before configure ..."
	tc qdisc del dev enp0s8 root
fi
