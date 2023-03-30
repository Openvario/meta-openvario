#!/bin/bash
# chkconfig: 2345 20 80
# description: Description comes here....

case "$1" in 
    start)
       # code to start app comes here 
       # example: daemon program_name &
       ;;
    stop)
	   RotationValue=$(cat /sys/class/graphics/fbcon/rotate)
	   sed -i "s/rotation=.*/rotation=$RotationValue/" /boot/config.uEnv
       ;;
    restart)
       # code to stop and start app comes here 
       # example: daemon program_name &
       ;;
    status)
       # code to check status of app comes here 
       # example: status program_name
       ;;
    *)
       echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0 