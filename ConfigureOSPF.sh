#!/bin/bash
command=/home/nbflab/Documents/scripts/Kommando.sh

zebra=/usr/local/etc/quagga/zebra.conf
ospf=/usr/local/etc/quagga/ospfd.conf

echo "Configuring OSPF routing on $1"

#$1: Name, $2: Ip-adress, $3: Adapter, $4: RouterID

if [ $# -lt 4 ]; then
         echo "###########################PELLE"
         #$command "sudo reboot" $1
	 exit
fi
ethPort=$(($3-1))
$command "sudo echo \"sudo ifconfig eth$ethPort $2\" >> /opt/bootlocal.sh" $1
echo "###################################################### ethPort: $ethPort"
echo "IP ADDRESS: $2"
echo "\$#: $#"
$command "sudo echo \"interface eth$ethPort\" >> $zebra" $1
$command "sudo echo \" ip address $2/24\" >> $zebra" $1
$command "sudo echo \" ipv6 nd suppress-ra\" >> $zebra" $1
$command "sudo echo \"!\" >> $zebra" $1

if [ $ethPort -eq 1 ]; then
        $command "sudo echo \"/usr/bin/sethostname $1\" >> /opt/bootsync.sh" $1
        $command "sudo /usr/local/sbin/ospfd -u root -d -f /usr/local/etc/quagga/ospfd.conf" $1
	$command "sudo echo \"/usr/local/sbin/ospfd -u root -d -f /usr/local/etc/quagga/ospfd.conf\" >> /opt/bootlocal.sh" $1
		
	$command "sudo echo \"router ospf\" >> $ospf" $1
        $command "sudo echo \" ospf router-id $4\" >> $ospf" $1
        $command "sudo echo \" passive-interface default\" >> $ospf" $1
        $command "sudo echo \" no passive-interface lo\" >> $ospf" $1
        $command "sudo echo \" network $4/32 area 0.0.0.0\" >> $ospf" $1
fi


$command "sudo echo \" no passive-interface eth$ethPort\" >> $ospf" $1
$command "sudo echo \" network $2/24 area 0.0.0.0\" >> $ospf" $1