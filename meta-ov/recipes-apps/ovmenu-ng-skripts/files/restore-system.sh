#!/bin/sh

# Transfer script for restore from usbstick

USB_PATH=/usb/usbstick/openvario/backup
MAC=`ip li|fgrep -A 1 eth0|head -n 2|cut -d ' ' -f 6|tail -n 1|sed -e s/:/-/g`

# We use -c here due to cubieboards not having an rtc clock
if rsync -r -c --progress "$USB_PATH/$MAC/" /; then
#if rsync --dry-run -r -c --progress "$USB_PATH/$MAC/" /; then
	echo 'All files transfered successfully.'
else
	EXIT=$?
	>&2 echo 'An error has occured!'
	exit $EXIT
fi

# Sync the buffer to be sure data is on disk
sync
echo 'Done !!'
