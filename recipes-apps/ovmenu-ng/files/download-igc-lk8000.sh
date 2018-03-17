#!/bin/bash

USB_PATH="/usb/usbstick/openvario/igc"
IGC_PATH="/home/root/LK8000/_Logger"
mkdir -p $USB_PATH

if [ -z "$(ls $IGC_PATH/*.igc 2>/dev/null)" ]; then
        echo "No files found !!!"
else
        for igcfile in $(find $IGC_PATH -name '*.igc'); do
                echo $igcfile
                cp $igcfile $USB_PATH
        done
fi

umount /dev/sda1
