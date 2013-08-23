#!/bin/bash
results=/home/nbflab/Documents/scripts/Results.txt


echo "$1:" >> $results
echo "Initiating listening on /tmp/$1Read"
nc -U "/tmp/""$1""Read" >> $results &