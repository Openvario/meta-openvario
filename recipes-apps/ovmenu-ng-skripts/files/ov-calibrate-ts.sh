#!/bin/sh
ROT=`cat /sys/class/graphics/fbcon/rotate`

# Perform the calibration
TSLIB_TSDEVICE=/dev/input/touchscreen0 ts_calibrate -r $ROT

echo "Applying the libinput calibration matrix according to current rotation ($ROT)"
case $ROT in
    0) ROTMATRIX="1 0 0 0 1 0" ;;
    1) ROTMATRIX="0 1 0 -1 0 1" ;;
    2) ROTMATRIX="-1 0 1 0 -1 1" ;;
    3) ROTMATRIX="0 -1 1 1 0 0" ;;
esac

echo "ENV{LIBINPUT_CALIBRATION_MATRIX}=\"$ROTMATRIX\"" > /etc/udev/rules.d/libinput-ts.rules
udevadm control --reload
udevadm trigger

echo Restart ts_uinput
systemctl restart ts_uinput

sync
