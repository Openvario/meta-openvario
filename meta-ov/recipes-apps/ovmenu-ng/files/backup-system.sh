#!/bin/sh

# Transfer script for backup to usbstick

USB_PATH=/usb/usbstick/openvario
MAC=`ip li|fgrep ether|tail -1|cut -d ' ' -f 6`

rsync --files-from - --archive --relative --mkpath --checksum \
	/ "$USB_PATH/backup/$MAC"/ <<LISTE || exit $?
/etc/dropbear
/etc/odpk
/etc/locale.conf
/var/lib/...
LISTE

# Sync the buffer to be sure data is on disk
sync
echo 'Done !!'
