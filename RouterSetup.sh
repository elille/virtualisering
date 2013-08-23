#! /bin/bash
# $1: Navn (må begynne på 'R'), $2: Ip-adresse på eth0, $3: Ip-adresse på eth1,
# $4: Router-id, $5: Nettverksnavn på eth0, $6: Nettverksnavn på eth1.

#$1: Navn, $2: Nettverksnavn, $3: Adapternr


if [ $# -lt 3 ]; then
        exit
fi

command=/home/nbflab/Documents/scripts/Kommando.sh
addNetwork=/home/nbflab/Documents/scripts/AddNetwork.sh

#Filepaths for routing configuration:
zebra=/usr/local/etc/quagga/zebra.conf
ospf=/usr/local/etc/quagga/ospfd.conf
if [ $2 -eq 2 ]; then
        echo "Creating new router $1"
#Cloning the router:
        VBoxManage clonevm RouterTemplate --name $1 --register

#Adding serial ports
        VBoxManage modifyvm $1 --uart1 0x3e8 4 --uartmode1 server "/tmp/"$1"Write"
        VBoxManage modifyvm $1 --uart2 0x2e8 3 --uartmode2 server "/tmp/"$1"Read"
fi
#Adding network interfaces
$addNetwork $1 $2 $3

exit
if [ $# -eq 8 ]; then
echo "################################################# \$8: $8"
$addNetwork $1 $7 4 $8
fi
#########       ALT UNDER DETTE MÅ SKRIVES ET ANNET STED! ############
#Booting router
echo "Booting router $1"
VBoxManage startvm $1
sleep 20
echo "Router $1 ready for configuration"

$command "echo \"/usr/bin/sethostname $1\" >> /opt/bootsync.sh" $1
$command "echo \"sudo ifconfig eth1 $2\" >> /opt/bootlocal.sh" $1
$command "echo \"sudo ifconfig eth2 $4\" >> /opt/bootlocal.sh" $1
if [ $# -eq 8 ]; then
$command "echo \"sudo ifconfig eth3 $7\" >> /opt/bootlocal.sh" $1
fi

#Zebra configuration
$command "sudo echo \"interface eth1\" >> $zebra" $1
$command "sudo echo \" ip address $2/24\" >> $zebra" $1
$command "sudo echo \" ipv6 nd suppress-ra\" >> $zebra" $1

$command "sudo echo \"interface eth2\" >> $zebra" $1
$command "sudo echo \" ip address $4/24\" >> $zebra" $1
$command "sudo echo \" ipv6 nd suppress-ra\" >> $zebra" $1

if [ $# -eq 8 ]; then
$command "sudo echo \"interface eth3\" >> $zebra" $1
$command "sudo echo \" ip address $7/24\" >> $zebra" $1
$command "sudo echo \" ipv6 nd suppress-ra\" >> $zebra" $1
fi

#OSPF configuration
$command "sudo echo \"router ospf\" >> $ospf" $1
$command "sudo echo \" ospf router-id $6\" >> $ospf" $1
$command "sudo echo \" passive-interface default\" >> $ospf" $1
$command "sudo echo \" no passive-interface eth1\" >> $ospf" $1
$command "sudo echo \" no passive-interface eth2\" >> $ospf" $1
if [ $# -eq 8 ]; then
$command "sudo echo \" no passive-interface eth3\" >> $ospf" $1
fi

$command "sudo echo \" no passive-interface lo\" >> $ospf" $1
echo "ROUTER-ID: $6"
echo "###########################################"
echo "\$7:$7"
$command "sudo echo \" network $6/32 area 0.0.0.0\" >> $ospf" $1
$command "sudo echo \" network $2/24 area 0.0.0.0\" >> $ospf" $1
$command "sudo echo \" network $4/24 area 0.0.0.0\" >> $ospf" $1
if [ $# -eq 8 ]; then
$command "sudo echo \" network $7/24 area 0.0.0.0\" >> $ospf" $1
fi

$command "/usr/bin/filetool.sh -b" $1
$command "sudo reboot" $1
