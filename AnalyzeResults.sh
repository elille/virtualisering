#!/bin/bash
testResults=/home/nbflab/Documents/scripts/TestResults.txt
results="/home/nbflab/Documents/scripts/"$1




i=0
MBytes=0
Mbits=0
maxMBytes=0
maxMDec=0
maxMbits=0
maxMbDec=0
minMBytes=1000000
minMbits=1000000
noBytes=0
noBits=0




for line in $(cat $results)
do
       if [ $line = "[" ]; then
               i=1
	       j=$((j+1))
	       continue
       fi
       
       if [ $i -gt 0 ]; then
       i=$(($i+1))
               if [ $line = "port" ]; then
               i=0
               continue
               fi
               if [ $i -eq 5 ]; then
	                decimal=${line##*.}
			line=${line%%.*}
			if [ $line -lt 100 ]; then
			       decimalByte=$(($decimalByte+$decimal)) 
			fi
			if [ $line -gt $maxMBytes ]; then
			       maxMBytes=$line
			elif [ $line -lt $minMBytes ]; then
			       minMBytes=$line
			fi
		        MBytes=$(($MBytes+$line))
			noBytes=$(($noBytes+1))
	       elif [ $i -eq 7 ]; then
			decimal=${line##*.}
			line=${line%%.*}
			if [ $line -lt 100 ]; then
			       decimalBit=$(($decimalBit+$decimal))
			fi
			if [ $line -gt $maxMbits ]; then
			       maxMbits=$line
			elif [ $line -lt $minMbits ]; then
			       minMbits=$line
			fi
			Mbits=$(($Mbits+$line))
			noBits=$(($noBits+1))
	       fi
               continue
       fi
       
done

decimalByte=$(($decimalByte/10))
echo ""
echo "DECIMAL: $decimalByte"
MBytes=$(($MBytes+$decimalByte))
avgBytes=$(awk -v MBytes=$MBytes 'BEGIN { print ((MBytes) / 100 ) }')

echo "Total MBytes: $MBytes"
echo "Avg MBytes: $avgBytes"
echo "Max MBytes: $maxMBytes"
echo "Min MBytes: $minMBytes"
echo "Number of Bytes counted: $noBytes"

echo "#####################################"
echo "#####################################"

decimalBit=$(($decimalBit/10))
Mbits=$(($Mbits+$decimalBit))
avgBits=$(awk -v Mbits=$Mbits 'BEGIN { print ((Mbits) / 100 ) }')

echo "Total bandwidth: $Mbits Mbits/sec"
echo "Avg bandwidth: $avgBits Mbits/sec"
echo "Max bandwidth: $maxMbits Mbits/sec"
echo "Min bandwidth: $minMbits Mbits/sec"
echo "Number of Bits counted: $noBits"
