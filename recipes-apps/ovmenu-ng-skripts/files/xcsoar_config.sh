#!/bin/bash

# Configuration variables
XCSOAR_CONFDIR="/home/root/.xcsoar/"


function display_rotation () {
	# getting config options
	TEMP=$(grep "rotation" /boot/config.uEnv)

	if [ -n $TEMP ]; then
        echo "Config string found"
        ROTATION=${TEMP: -1}
        echo "Rotation" $ROTATION

        case "$ROTATION" in

        0) XCSOAR_ROTATION=2
		;;
        1) XCSOAR_ROTATION=1
        ;;
        2) XCSOAR_ROTATION=4
        ;;
        3) XCSOAR_ROTATION=3
        ;;
        esac

        echo "Replacing ... XCSOAR_ROTATION="$XCSOAR_ROTATION
		sed -i 's/^DisplayOrientation=.*/DisplayOrientation="'$XCSOAR_ROTATION'"/' $XCSOAR_CONFDIR/*.prf
		sed -i 's/^DisplayOrientation=.*/DisplayOrientation="'$XCSOAR_ROTATION'"/' $XCSOAR_CONFDIR/default.top
fi
}

#main
echo "XCSoar config file adaption"

echo "Mount config dir ..."
mount /dev/mmcblk0p1 /boot

echo "Doing DisplayOrientation ..."
display_rotation

echo "Unmount config dir ..."
umount /dev/mmcblk0p1
echo "Exiting ..."
