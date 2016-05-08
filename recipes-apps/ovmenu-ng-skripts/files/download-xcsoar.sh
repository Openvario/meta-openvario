#!/bin/bash

USB_PATH="/usb/usbstick/openvario/download/xcsoar"
DOWNLOAD_PATH="/home/root/.xcsoar"
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

