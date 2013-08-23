#$1 = navn på vm, $2: Ip-adresse nr. 1, $3: Ip-adresse nr. 2, $4: Default gw
#Alle switcher har en bridge, med eth0 og eth1
#Det som må settes er hvilke nettverk den er koblet til, og ifconfige dem

if [ $# -ne 1 ]
then
	echo "$0: This script takes one argument: The name of the VM, you provided $#."
	exit
fi
addNetwork=/home/nbflab/Documents/scripts/AddNetwork.sh
command=/home/nbflab/Documents/scripts/Kommando.sh

VBoxManage clonevm SwitchTemplate --name $1 --register

#Setting up serial ports:
VBoxManage modifyvm $1 --uart1 0x3e8 4 --uartmode1 server "/tmp/"$1"Write"
VBoxManage modifyvm $1 --uart2 0x2e8 3 --uartmode2 server "/tmp/"$1"Read"

#####################
exit
echo "$0: FAILED TO EXIT!"
#Adding networks:
$addNetwork $1 $2 2 $3
$addNetwork $1 $4 3 $5

#Booting for configuration:
VBoxManage startvm $1
echo "Booting switch $1"
sleep 20
echo "Starting $1 configuration"

#Configuration commands
$command "echo \"/usr/bin/sethostname $1\" >> /opt/bootsync.sh" $1
$command "echo \"sudo ifconfig eth1 $2\" >> /opt/bootsync.sh" $1
$command "echo \"sudo ifconfig eth2 $3
