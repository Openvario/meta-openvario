#!/bin/bash

USB_PATH="/usb/usbstick/openvario/download/LK8000"
DOWNLOAD_PATH="/LK8000"
if [ ! -d "$USB_PATH" ]; then
	mkdir "$USB_PATH"
fi
if [ -z "$(ls $DOWNLOAD_PATH/* 2>/dev/null)" ]; then
        echo "No files found !!!"
else
        for downloadfile in $(find $DOWNLOAD_PATH -type f); do
                echo $downloadfile
                cp $downloadfile $USB_PATH
        done
fi

echo "Umount Stick ..."
umount /dev/sda1
echo "Done !!"
