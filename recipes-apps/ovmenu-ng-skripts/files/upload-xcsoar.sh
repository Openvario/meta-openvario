#!/bin/bash

USB_PATH="/usb/usbstick/openvario/upload"
UPLOAD_PATH="/home/root/.xcsoar"
if [ -z "$(ls $USB_PATH/* 2>/dev/null)" ]; then
        echo "No files found !!!"
else
        for uploadfile in $(find $USB_PATH -type f); do
                echo $uploadfile
                cp $uploadfile $UPLOAD_PATH
        done
fi
echo "Umount Stick ..."
umount /dev/sda1
echo "Done !!"