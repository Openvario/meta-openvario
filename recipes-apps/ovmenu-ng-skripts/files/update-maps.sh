#!/bin/bash

MAP_PATH="/usb/usbstick/openvario/maps"

if [ -z "$(ls $MAP_PATH/xcsoar-maps*.ipk 2>/dev/null)" ]; then
        echo "No files for update found !!!"
else
        for mapfile in $(find $MAP_PATH -name 'xcsoar-maps*.ipk'); do
                echo $mapfile
                opkg install $mapfile
        done
fi

umount /dev/sda1
