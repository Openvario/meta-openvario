#!/bin/bash

USB_PATH="/usb/usbstick/openvario/download/xcsoar"
DOWNLOAD_PATH="/home/root/.xcsoar"
SAVE_FILE="${USB_PATH}/xcs-`date +'%Y-%m-%d'`.tgz"
if [ ! -d "$USB_PATH" ]; then
	mkdir "$USB_PATH"
fi

if [ -z "$(ls $DOWNLOAD_PATH/* 2>/dev/null)" ]; then
        echo "No files found !!!"
else
	cd ${DOWNLOAD_PATH}
	tar czf "${SAVE_FILE}" .
fi

ls -l "${SAVE_FILE}"
echo "Umount Stick ..."
umount /dev/sda1
echo "Done !!"

