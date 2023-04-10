#!/bin/bash
XCSOAR_MAP_PATH="/home/root/.xcsoar"
MAP_PATH="/usb/usbstick/openvario/maps"

if [ -z "$(ls $MAP_PATH/xcsoar-maps*.ipk 2>/dev/null)" ]; then
        echo "No *.ipk files for update found !!!"
else
        for mapfile in $(find $MAP_PATH -name 'xcsoar-maps*.ipk'); do
                echo $mapfile
                opkg install $mapfile
        done
fi

if [ -z "$(ls $MAP_PATH/*.xcm 2>/dev/null)" ]; then
        echo "No *.xcm files for update found !!!"
else
        for mapfile in $(find $MAP_PATH -name '*.xcm'); do
                echo $mapfile
                cp $mapfile $XCSOAR_MAP_PATH
        done
fi

sync
umount /dev/sda1
echo "Done !!"
