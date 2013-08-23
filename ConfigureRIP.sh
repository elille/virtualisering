#!/bin/bash

command=/home/nbflab/Documents/scripts/Kommando.sh

zebra=/usr/local/etc/quagga/zebra.conf
rip=/usr/local/etc/quagga/ripd.conf

echo "Configuring RIP routing on $1"
echo "\$1: $1, \$2: $2, \$3: $3, \$4: $4"

if [ $# -lt 4 ]; then
        exit
fi

ethPort=$(($3-1))
$command "sudo echo \"sudo ifconfig eth$ethPort $2\" >> /opt/bootlocal.sh" $1

$command "sudo echo \"interface eth$ethPort\" >> $zebra" $1
$command "sudo echo \" ip address $2/24\" >> $zebra" $1
$command "sudo echo \" ipv6 nd suppress-ra\" >> $zebra" $1
$command "sudo echo \"!\" >> $zebra" $1

if [ $ethPort -eq 1 ]; then
        $command "sudo echo \"/usr/bin/sethostname $1\" >> /opt/bootsync.sh" $1
        $command "sudo /usr/local/sbin/ripd -u root -d -f /usr/local/etc/quagga/ripd.conf" $1
        $command "sudo echo \"/usr/local/sbin/ripd -u root -d -f /usr/local/etc/quagga/ripd.conf\" >> /opt/bootlocal.sh" $1
	
	$command "sudo echo \"router rip\" >> $rip" $1
	##EKSPERIMENT
	#$command "sudo echo \" rip router-id $4\" >> $rip" $1
	$command "sudo echo \" passive-interface default\" >> $rip" $1
	$command "sudo echo \" no passive-interface lo\" >> $rip" $1
fi

$command "sudo echo \" no passive-interface eth$ethPort\" >> $rip" $1
$command "sudo echo \" network $2/24\" >> $rip" $1
$command "sudo echo \" network eth$ethPort\" >> $rip" $1
