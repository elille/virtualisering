#$1: VM-navn, $2: Nettverksadapter, $3: Nettverksnavn

if [ $# -ne 3 ]
then
	echo "$0: 3 arguments required, $# given"
	echo "\$1: $1, \$2: $2, \$3: $3"
	exit
fi

VBoxManage modifyvm $1 --nic$2 intnet
VBoxManage modifyvm $1 --intnet$2 $3
VBoxManage modifyvm $1 --nicpromisc$2 allow-all --macaddress$2 auto 
command=/home/nbflab/Documents/scripts/Kommando.sh


