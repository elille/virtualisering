#!/bin/bash

command=/home/nbflab/Documents/scripts/Kommando.sh

echo "Virtual Machine $1 ready for configuration"

$command "sudo echo \"/usr/bin/sethostname $1\" >> /opt/bootsync.sh " $1
$command "sudo echo \"sudo ifconfig eth1 $2\" >> /opt/bootlocal.sh " $1
$command "sudo ifconfig eth1 $2" $1

#Default gw

split=$(echo $2 | tr "." "\n")
i=1
gw=""

for x in $split
do
        if [ $i -lt 4 ]; then
                gw=$gw$x"."
        else
                gw=$gw"1"
        fi
        i=$(($i+1))
done
echo "$1 default gw: $gw"

$command "sudo route add default gw $gw" $1

$command "/usr/bin/filetool.sh -b" $1