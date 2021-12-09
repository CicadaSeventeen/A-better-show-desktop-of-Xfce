#! /bin/bash
function show_desktop(){
    temID=$(xdotool getwindowfocus)
    Desktop=$(xdotool search --class xfdesktop)
    echo $Desktop|grep $temID
    flag=$?
    	while [[ $flag -eq 1 ]]
        do
            sleep $1
            xdotool windowminimize $temID
            sudo bash -c "echo $temID >>/tmp/.window_list"
            temID2=$(xdotool getwindowfocus)
	    if [[ x"$temID" == x"$temID2" ]] ; then
		(xdotool search --class xfdesktop)|grep $temID
		if [[ $? -eq 0 ]] ; then
		flag=0
		fi
	    else
		temID=$temID2
	    fi
    	done
}


function show_window(){
    for line in $(tac /tmp/.window_list)
    do
        sleep $1
        xdotool windowactivate $line &>/dev/null
    done
    sudo bash -c "cat /dev/null > /tmp/.window_list"
}

function auto_change(){
    temID=$(xdotool getwindowfocus)
    Desktop=$(xdotool search --class xfdesktop)
    echo $Desktop|grep $temID
    flag=$?
	echo $Desktop >>~/temtest.txt
	echo $temID >>~/temtest.txt
	echo '///' >>~/temtest.txt
    if [ $flag == 0 ] ; then
	    show_window $1    
    elif [ $flag == 1 ] ; then
	sudo bash -c "cat /dev/null > /tmp/.window_list"
	while [[ $flag -eq 1 ]]
        do
            sleep $1
            xdotool windowminimize $temID
            sudo bash -c "echo $temID >>/tmp/.window_list"
            temID2=$(xdotool getwindowfocus)
	    if [[ x"$temID" == x"$temID2" ]] ; then
		(xdotool search --class xfdesktop)|grep $temID
		if [[ $? -eq 0 ]] ; then
		flag=0
		fi
	    else
		temID=$temID2
	    fi
    	done
    fi
}

if [[ "$1" == "--rs" ]] ; then
	sudo bash -c "rm /tmp/.display_desktop_lock"
fi
sudo bash -c "echo $$ >>/tmp/.display_desktop_lock"
sleep 0.02
[ "x$(cat /tmp/.display_desktop_lock)" == "x"$$ ] || exit 1
for command in $1 ; do
        if [[ "$command" == "--sd" ]] ; then
	       sudo bash -c "cat /dev/null > /tmp/.window_list"
               show_desktop ${2:-0.02}
        elif [[ "$command" == "--sw" ]] ; then
               show_window ${2:-0.02}
        elif [[ "$command" == "--auto" ]] ; then
               auto_change ${2:-0.02}
        elif [[ "$command" == "--rs" ]] ; then
		echo 'restarted'
        else
		echo 'Please input'
		echo -e "--sd time\tto show desktop"
		echo -e "--sw time\tto show windows"
		echo -e "--auto time\tto automaticly change status"
		echo -e "--rs\t\tto restart this program if any bugs happen"
		echo 'time is the waiting time for changing window in second, 0.02s as default. Please donot input number larger than 1 sec'
	fi
done
sudo bash -c "cat /dev/null >/tmp/.display_desktop_lock"
exit 0

