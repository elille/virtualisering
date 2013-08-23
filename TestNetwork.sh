#!/bin/bash

command=/home/nbflab/Documents/scripts/Kommando.sh
results=/home/nbflab/Documents/scripts/Results.txt
results2=/home/nbflab/Documents/scripts/ResultsII.txt
results3=/home/nbflab/Documents/scripts/ResultsIII.txt

$command "iperf -s" MicroCore2
#$command "iperf -s" MicroCore4
#$command "iperf -s" MicroCore6
#$command "iperf -s" MicroCore8
#$command "iperf -s" MicroCOre10

for (( i=1; i<=100; i++ ))
do 
	$command "iperf -c 192.168.2.50" MicroCore1
	#$command "iperf -c 192.168.4.50" MicroCore3
        #$command "iperf -c 192.168.6.50" MicroCore5
	#$command "iperf -c 192.168.8.50" MicroCore7
	#$command "iperf -c 192.168.110.50" MicroCore9
	sleep 10
	echo "I: $i"
	echo "I: $i" >> $results
	echo "I: $i" >> $results2
	echo "I: $i" >> $results3

done

for (( i=1; i<=10; i++ ))
do
       echo "####################################################################"
       sleep 1
done
echo "DONE"
echo "--------------------------------------------------------------------"
echo "####################################################################"