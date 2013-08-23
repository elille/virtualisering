#!/bin/bash
# $1: Kommando, $2: Navn på vm


if [ "$#" -ne 2 ]
then
	echo "$0: 2 arguments required, $# given."
	echo "\$1: Kommando, \$2: Navn på VM."
	exit

fi
echo "Executing remote command $1"


writepath="/tmp/"$2"Write"
readpath="/tmp/"$2"Read"
#echo "Skriveport: $writepath"
#echo "leseport: $readpath"

# PREPARING TO DISPLAY OUTPUT
nc -U $readpath &

#echo "Listening initiated"

# EXECUTE COMMAND REMOTELY
#echo "Executing remote command $1"

echo "$1" | nc -U $writepath

#echo "/usr/bin/filetool.sh -b" | nc -U $writepath &
#sleep 5




