#!/bin/sh

# Transfer script for restore from usbstick

USB_PATH=/usb/usbstick/openvario/backup
MAC=`ip li|fgrep ether|tail -1|cut -d ' ' -f 6`

# We use -c here due to cubieboards not having an rtc clock
#if rsync -r -c --progress "$USB_PATH/" /; then
if rsync --dry-run -r -c --progress "$USB_PATH/$MAC/" /; then
	echo 'All files transfered successfully.'
else
	EXIT=$?
	>&2 echo 'An error has occured!'
	exit $EXIT
fi

# Sync the buffer to be sure data is on disk
sync
echo 'Done !!'
