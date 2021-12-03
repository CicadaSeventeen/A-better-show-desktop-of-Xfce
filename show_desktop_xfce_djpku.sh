#! /bin/bash
function show_desktop(){
    temID=$(xdotool getwindowfocus)
    xdotool search --class xfdesktop|grep $temID &>/dev/null
    while [[ $? -eq 1 ]]
        do
            sleep $1
            xdotool windowminimize $temID
            sudo bash -c "echo $temID >>/tmp/.window_list"
            temID=$(xdotool getwindowfocus)
            xdotool search --class xfdesktop|grep $temID &>/dev/null
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
    xdotool search --class xfdesktop|grep $temID
    tem=$?
    echo $tem &>>/home/jydeng/tem.txt
    if [ $tem == 0 ] ; then
	    show_window $1    
    elif [ $tem == 1 ] ; then
	    sudo bash -c "cat /dev/null > /tmp/.window_list"
	    show_desktop $1
    fi
}

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
	else
		echo 'Please input'
		echo '--sd time   to show desktop'
		echo '--sw time   to show windows'
		echo '--auto time     to automaticly change status'
		echo 'time is the waiting time for changing window in 0second, 0.02s as default'
        fi
done
sudo bash -c "cat /dev/null >/tmp/.display_desktop_lock"
exit 0
