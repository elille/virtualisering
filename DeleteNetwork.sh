for (( i=1; i<=18; i++ ))
do
        VBoxManage controlvm "MicroCore"$i poweroff
	VBoxManage controlvm "Switch"$i poweroff
	VBoxManage controlvm "Router"$i poweroff
done

sleep 3

for (( i=1; i<=18; i++))
do 
        VBoxManage unregistervm "MicroCore"$i --delete
	VBoxManage unregistervm "Switch"$i --delete
	VBoxManage unregistervm "Router"$i --delete
done