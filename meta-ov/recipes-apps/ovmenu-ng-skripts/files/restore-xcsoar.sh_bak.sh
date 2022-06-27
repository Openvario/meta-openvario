#!/bin/sh
#
# System restore transfer script to usbstick for XCSoar
#
# 7lima & Blaubart, 2022-06-19
#
# This script restores all XCSoar settings
# 
# The script uses backups, they are stored at USB stick at:
# openvario/backup/"MAC address of eth0
#
# So you can use an USB sticks, where more than one backup is stored!

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick
# Backup path on the USB stick
BACKUP=openvario/backup
# MAC address of the Ethernet device eth0 to restore the separate backup
MAC=`ip li|grep -A 1 eth0|tail -n 1|cut -d ' ' -f 6|sed -e s/:/-/g`

echo ' Starting restore of XCSoar...'
echo ' Wait until "DONE !!" appears before you exit!'

if 
# Copy all files and dirs recursively.
# We use -c here due to cubieboards not having an rtc clock
	rsync --recursive --mkpath --checksum --quiet "$USB_PATH/$BACKUP/$MAC"/home/root.xcsoar/ /home/root.xcsoar
	RSYNC_EXIT=$?
# Sync the buffer to be sure data is on disk
	sync
	test $RSYNC_EXIT -eq 0
then
	echo ' All XCSoar files have been restored.'
else 
	echo " An error $RSYNC_EXIT has occurred!"
	echo ' DONE !!' 
	exit $RSYNC_EXIT
fi

echo ' DONE !!' 
exit 0
