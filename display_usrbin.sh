#! /bin/bash
function show_desktop_core(){
    sudo bash -c "cat /dev/null > /tmp/.window_list"
    temID=$(xdotool getwindowfocus)
    echo $* |grep $temID
    flag=$?
    while [[ $flag -eq 1 ]]
        do
            sleep $1
            xdotool windowminimize $temID
            sudo bash -c "echo $temID >>/tmp/.window_list"
            temID=$(xdotool getwindowfocus)
	    echo $*|grep $temID
	    flag=$?
    done
}

function show_desktop(){
    temID=$(xdotool getwindowfocus)
    Desktop=$(xdotool search --onlyvisible --class xfdesktop)
    echo $Desktop|grep $temID
    flag=$?
    if [[ $flag -eq 1 ]] ; then
	show_desktop_core $1 "$Desktop"
    fi
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
    Desktop=$(xdotool search --onlyvisible --class xfdesktop)
    echo $Desktop|grep $temID
    tem=$?
    if [ $tem == 0 ] ; then
	    show_window $1    
    elif [ $tem == 1 ] ; then
	    sudo bash -c "cat /dev/null > /tmp/.window_list"
	    show_desktop_core $1 "$Desktop"
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

