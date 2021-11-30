#! /bin/bash 
FILEPATH=/.SHOWDESKTOP_DJYPKU
function auto_change(){
    temID=$(xdotool getwindowfocus)
    xdotool search --class xfdesktop|grep $temID
    tem=$?
    echo $tem &>>/home/jydeng/tem.txt
    if [ $tem == 0 ] ; then
	    /$FILEPATH/show_window.sh $1    
    elif [ $tem == 1 ] ; then
#	    /$FILEPATH/show_desktop.sh $1
    fi
}

for command in $1 ; do
        if [[ "$command" == "--sd" ]] ; then
               /$FILEPATH/show_desktop.sh $2
        elif [[ "$command" == "--sw" ]] ; then
               /$FILEPATH/show_window.sh $2
        elif [[ "$command" == "--auto" ]] ; then
               auto_change $2
        fi
done