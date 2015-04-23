#!/bin/bash

USB_PATH="/usb/usbstick/openvario/igc"
IGC_PATH="/root/"
if [ -z "$(ls $MAP_PATH/*.igc 2>/dev/null)" ]; then
        echo "No files found !!!"
else
        for igcfile in $(find $MAP_PATH -name '*.igc'); do
                echo $igcfile
                cp $igcfile $USB_PATH
        done
fi

umount /dev/sda1
