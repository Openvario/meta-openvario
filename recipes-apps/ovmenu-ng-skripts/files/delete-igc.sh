#!/bin/bash

USB_PATH="/usb/usbstick/openvario/igc"
IGC_PATH="/home/root/.xcsoar/logs"

if [ -z "$(ls $IGC_PATH/*.igc 2>/dev/null)" ]; then
        echo "No files found !!!"
else
        for igcfile in $(find $IGC_PATH -name '*.igc'); do
                echo $igcfile
                rm $igcfile
        done
fi
echo "Done!"

