#!/bin/bash

USB_PATH="/usb/usbstick/openvario/upload/LK8000"
UPLOAD_PATH="/LK8000"
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
