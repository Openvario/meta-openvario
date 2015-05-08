#!/bin/bash

USB_PATH="/usb/usbstick/openvario/igc"
IGC_PATH="/home/root/.xcsoar/logs"
if [ -z "$(ls $IGC_PATH/*.igc 2>/dev/null)" ]; then
        echo "No files found !!!"
else
        for igcfile in $(find $IGC_PATH -name '*.igc'); do
                echo $igcfile
                cp $igcfile $USB_PATH
        done
fi

read -t 5 -n 1 -p $'Hit any key to continue or wait 5 seconds ...\n'

umount /dev/sda1
