#!/bin/sh
#
# Transfer script for OpenVario backup to usbstick
# 7lima, 2022-06-19

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick/openvario
# MAC address of the first Ethernet device to do a separate backup
MAC=`ip li|fgrep -A 1 eth0|head -n 2|cut -d ' ' -f 6|tail -n 1|sed -e s/:/-/g`

# Copy all directories and files from (example) list below to backup directory
echo "/etc/dropbear
/etc/opkg
/etc/locale.conf
/home/root
/opt/conf
/var/lib/connman
/boot/config.uEnv
/sys/class/backlight/lcd/brightness" |
rsync --files-from - -v --archive --recursive --relative --mkpath --checksum \
	/ "$USB_PATH/backup/$MAC"/ || exit $?

## Copy all directories and files from (example) list below to backup directory
#rsync --files-from - -v --archive --recursive --relative --mkpath --checksum \
#	/ "$USB_PATH/backup/$MAC"/ <<LIST || exit $?
#/etc/dropbear
#/etc/odpk
#/etc/locale.conf
#...
#/adapt/to/your/needs
#LIST

# Sync the buffer to be sure data is on disk
sync
echo Done '!!' 
