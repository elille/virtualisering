#!/bin/bash

command=/home/nbflab/Documents/scripts/Kommando.sh
zebra=/usr/local/etc/quagga/zebra.conf

echo "Configuring static routing on $1"
echo "\$1: $1, \$2: $2, \$3: $3, \$4: $4"

if [ $# -lt 4 ]; then
       exit
fi

ethPort=$(($3-1))
$command "sudo echo \"sudo ifconfig eth$ethPort $2\" >> /opt/bootlocal.sh" $1

$command "sudo echo \"interface eth$ethPort\" >> $zebra" $1
$command "sudo echo \" ip address $2/24\" >> $zebra" $1
$command "sudo echo \"!\" >> $zebra" $1

if [ $ethPort -eq 1 ]; then
        $command "sudo echo \"/usr/bin/sethostname $1\" >> /opt/bootsync.sh" $1
fi

split=$(echo $2 | tr "." "\n")
i=1
gw=""

for x in $split
do
        if [ $i -eq 3 ]; then
	        mod=$(($x/2))
		if [ $mod -ne 1 ]; then
		        break
		fi
	fi
	
	if [ $i -lt 4 ]; then
	        gw=$gw$x"."
	else
		if [ $x -eq 1 ]; then
			gw=$gw"2"
		else
		        gw=$gw"1"
		fi
		echo "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHAPPENED----------------"
		$command "sudo echo \" sudo route add default gw $gw\" >> /opt/bootlocal.sh" $1
	fi
	
	i=$(($i+1))
done

echo "########################## GW : $gw"
$command "sudo echo \"ip route 0.0.0.0/0 eth$ethPort\" >> $zebra" $1
$command "sudo echo \"!\" >> $zebra" $1

#$command "sudo route add default gw $gw" $1 











