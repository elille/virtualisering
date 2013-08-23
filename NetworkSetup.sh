#!/bin/bash
echo "Setting up virtual network"

#All configuration requires two for-loops: One to clone the Virtual Machine
#and set up networks and serial ports, and one to communicate settings
#through the serial port after boot. The VM can not be booted for network
#settings, but has to be booted for communication. To be sure that the
#machine is ready to receive commands over the serial ports, one must
#wait cirka 20 seconds after boot, hence the sleep.
#To minimize the running time, the serial port communication has been
#put together so that there is only one sleep necessary.
#The router configuration happens in parallel to eachother so that
#the runtime is as short as possible.

#Flaws: All for loops within the other for loops are fixed-length,
#which will cause problems if for instance a switch with 3 or 5 
#ports is introduced. The switches and routers array will need to
#be updated when adding more of these units. 
#RouterSetup.sh is clumsy, and takes a varying amount of arguments.

#Preparing scripts:
addNetwork=/home/nbflab/Documents/scripts/AddNetwork.sh
command=/home/nbflab/Documents/scripts/Kommando.sh
vmSetup=/home/nbflab/Documents/scripts/VMSetup.sh
switchSetup=/home/nbflab/Documents/scripts/SwitchSetup.sh
routerSetup=/home/nbflab/Documents/scripts/RouterSetup.sh
configureVM=/home/nbflab/Documents/scripts/ConfigureVM.sh
configureOSPF=/home/nbflab/Documents/scripts/ConfigureOSPF.sh
configureRIP=/home/nbflab/Documents/scripts/ConfigureRIP.sh
configureStatic=/home/nbflab/Documents/scripts/ConfigureStatic.sh

#Host network configuration data
#hostIP=("192.168.1.50" "192.168.2.50" "192.168.3.50" "192.168.4.50" "192.168.5.50" "192.168.6.50")
#hostNetworkNames=("hostCable1" "hostCable2" "hostCable3" "hostCable4" "hostCable5" "hostCable6")
hostIP=("192.168.1.50" "192.168.2.50" "192.168.3.50" "192.168.4.50" "192.168.5.50" "192.168.6.50" "192.168.7.50" "192.168.8.50")
hostNetworkNames=("hostCable1" "hostCable2" "hostCable3" "hostCable4" "hostCable5" "hostCable6" "hostCable6" "hostCable7" "hostCable8")

#Switch network data
#declare -a switch1=("hostCable1:192.168.1.20" "hostCable2:192.168.2.21" "hostCable3:192.168.2.22" "routerCable1:192.168.2.23")
#declare -a switch2=("hostCable4:192.168.4.20" "hostCable5:192.168.4.21" "hostCable6:192.168.4.22" "routerCable2:192.168.4.23")
#declare -a switch3=("hostCable7:192.168.3.20" "hostCable8:192.168.3.21" "routerCable3:192.168.3.22" "routerCable4:192.168.3.23")
#declare -a switch4=("hostCable9:10.42.4.20" "hostCable10:10.42.4.21" "hostCable11:10.42.4.22" "routerCable5:10.42.4.23")
#switches=( Switch1 Switch2 Switch3 Switch4 )

#Router network data
declare -a router1=("hostCable1:192.168.1.1" "routerCable1:192.168.11.1" "routerCable3:192.168.13.1")
declare -a router2=("routerCable1:192.168.11.2" "routerCable2:192.168.12.1" "routerCable4:192.168.14.1")
declare -a router3=("hostCable2:192.168.2.1" "routerCable2:192.168.12.2" "routerCabal5:192.168.15.1")

declare -a router4=("hostCable3:192.168.3.1" "routerCable3:192.168.13.2" "routerCable6:192.168.16.1" "routerCable8:192.168.18.1")
declare -a router5=("routerCable4:192.168.14.2" "routerCable6:192.168.16.2" "routerCable7:192.168.17.1" "routerCable9:192.168.19.1")
declare -a router6=("hostCable4:192.168.4.1" "routerCable5:192.168.15.2" "routerCable7:192.168.17.2" "routerCable10:192.168.20.1")

declare -a router7=("hostCable5:192.168.5.1" "routerCable8:192.168.18.2" "routerCable11:192.168.21.1" "routerCable13:192.168.23.1")
declare -a router8=("routerCable9:192.168.19.2" "routerCable11:192.168.21.2" "routerCable12:192.168.22.1" "routerCable14:192.168.24.1")
declare -a router9=("hostCable6:192.168.6.1" "routerCable10:192.168.20.2" "routerCable12:192.168.22.2" "routerCable15:192.168.25.1")

declare -a router10=("hostCable7:192.168.7.1" "routerCable13:192.168.23.2" "routerCable16:192.168.26.1")
declare -a router11=("routerCable14:192.168.24.2" "routerCable16:192.168.26.2" "routerCable17:192.168.27.1")
declare -a router12=("hostCable8:192.168.8.1" "routerCable15:192.168.25.2" "routerCable17:192.168.27.2")

#declare -a router13=("hostCable9:192.168.9.1" "routerCable18:192.168.28.2" "routerCable21:192.168.31.1")
#declare -a router14=("routerCable19:192.168.29.1" "routerCable21:192.168.31.2" "routerCable22:192.168.32.1")
#declare -a router15=("hostCable10:192.168.110.1" "routerCable20:192.168.30.2" "routerCable22:192.168.32.2")

routers=( Router1 Router2 Router3 Router4 Router5 Router6 Router7 Router8 Router9 Router10 Router11 Router12 )

#The preferred routing mode is set to 1, the rest to 0
OSPF=0
RIP=1
STATIC=0

################################################################
###########  DON'T CHANGE ANYTHING BELOW THESE LINES




numberOfHosts="${#hostIP[@]}"
#Cloning hosts and setting up serial ports and networks
for (( i=1; i<=$numberOfHosts; i++ ))
do
	$vmSetup "MicroCore""$i" "${hostNetworkNames[$(($i-1))]}"
done

#Setting up switches: Serial ports and networks

numberOfSwitches="${#switches[@]}"
for (( i=1; i<=$numberOfSwitches; i++ ))
do
	$switchSetup "Switch"$i
	for (( j=1; j<=7; j++))
	do
		adapterNo=$(($j+1))
		varString="switch$i[$((j-1))]"
		networkData=${!varString}
		netName=${networkData%%:*}
		if [ $netName ]; then
		        $addNetwork "Switch"$i $adapterNo $netName
	        else
		        break
		fi
	done
	VBoxManage startvm "Switch"$i &
done


#Configuring routers
numberOfRouters="${#routers[@]}"
for (( i=1; i<=$numberOfRouters; i++))
do
	for (( j=1; j<=7; j++))
	do
	        varString="router$i[$(($j-1))]"
		networkData=${!varString}
		netName=${networkData%%:*}
		adapterNo=$(($j+1))
		if [ $netName ]; then
		        $routerSetup "Router"$i $adapterNo $netName
		else
		        break
		fi
        done
	
	VBoxManage startvm "Router"$i &
	sleep 5

done

#Sleeping in order to have machines ready for serial port communication
sleep 150


#Configuring settings on hosts through serial ports
for (( i=1; i<=$numberOfHosts; i++ ))
do
        echo "MicroCore"$i
	$configureVM "MicroCore""$i" "${hostIP[$(($i-1))]}"
done

#Writing settings to switch via serial ports
for (( i=1; i<=$numberOfSwitches; i++ ))
do
        $command "sudo echo \" /usr/bin/sethostname Switch$i\" >> /opt/bootsync.sh" "Switch"$i
	for (( j=1; j<=7; j++))
	do
		varString="switch$i[$(($j-1))]"
		networkData=${!varString}
		ipAddress=${networkData##*:}
	        $command "sudo ifconfig eth$j $ipAddress" "Switch"$i
	        if [ $ipAddress ]; then
		        $command "echo \"sudo ifconfig eth$j $ipAddress\" >> /opt/bootlocal.sh" "Switch"$i
		else
		        break
		fi
	done
	$command "/usr/bin/filetool.sh -b" "Switch"$i
done

#Configuring router settings through serial ports
for (( i=1; i<=$numberOfRouters; i++))
do
        for (( j=1; j<=7; j++))
	do
	       adapterNo=$(($j+1))
	       varString="router$i[$(($j-1))]"
	       networkData=${!varString}
	       ipAddress=${networkData##*:}
	       if [ $ipAddress ] && [ $OSPF -eq 1 ]; then
	               echo "################# OSPF: $OSPF"
	               $configureOSPF "Router"$i $ipAddress $adapterNo "5.5.5."$i
	       elif [ $ipAddress ] && [ $RIP -eq 1 ]; then
	               echo "################## RIP"
	               $configureRIP "Router"$i $ipAddress $adapterNo "5.5.5."$i
	       elif [ $ipAddress ] && [ $STATIC -eq 1 ]; then
	               echo "################# STATIC"
		       $configureStatic "Router"$i $ipAddress $adapterNo $i
	       else
	               echo "FERDIG : Router$i"
		       $command "/usr/bin/filetool.sh -b" "Router"$i
		       $command "sudo reboot" "Router"$i
		       echo "--------------------REBOOT"
		       break
	       fi
	      # $command "/usr/bin/filetool.sh -b" "Router"$i
	      # $command "sudo reboot" "Router"$i
	done
done


