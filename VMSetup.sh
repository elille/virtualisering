#!/bin/bash


echo "Setting up Virtual Machine $1"
writepath="/tmp/"$1"Write"
readpath="/tmp/"$1"Read"

addNetwork=/home/nbflab/Documents/scripts/AddNetwork.sh
routerSetup=/home/nbflab/Documents/scripts/RouterSetup.sh
command=/home/nbflab/Documents/scripts/Kommando.sh


if [ $# -ne 2 ]; then
	echo "$0: ERROR: Three arguments required, you provided $#."
	echo "Arguments required: \$1: Name of VM, \$2: Name of network."
	exit
fi

VBoxManage clonevm MicroCoreTemplate --name $1 --register

#Adding serial ports
VBoxManage modifyvm $1 --uart1 0x3e8 4 --uartmode1 server $writepath
VBoxManage modifyvm $1 --uart2 0x2e8 3 --uartmode2 server $readpath


$addNetwork $1 2 $2


VBoxManage startvm $1 &
echo "Booting virtual machine $1"



