#!/bin/sh
#
# Transfer script for OpenVario backup to usbstick
# 7lima, 2022-06-19

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick/openvario

# MAC address of the Ethernet device eth0 to do a separate backup
MAC=`ip li|fgrep -A 1 eth0|head -n 2|cut -d ' ' -f 6|tail -n 1|sed -e s/:/-/g`

# Store SSH-status 
if /bin/systemctl --quiet is-enabled dropbear.socket; then
	>/home/root/ssh-status
	echo enabled >> /home/root/ssh-status
	
elif /bin/systemctl --quiet is-active dropbear.socket; then
	>/home/root/ssh-status
	echo temporary >> /home/root/ssh-status
	
else 
	>/home/root/ssh-status
	echo disabled >> /home/root/ssh-status
	
fi

# Copy brightness setting
>/home/root/brightness
cat /sys/class/backlight/lcd/brightness >> /home/root/brightness

# Copy all directories and files from list below to backup directory
echo "/etc/locale.conf
/etc/udev/rules.d/libinput-ts.rules
/etc/pointercal
/etc/dropbear
/etc/opkg
/home/root
/opt/conf
/var/lib/connman
/boot/config.uEnv
" |
if rsync --files-from - -v --archive --recursive --quiet --relative --mkpath --checksum --safe-links\
	/ "$USB_PATH/backup/$MAC"/ || exit $?; then
	echo -e ' All files have been backed up. \n Wait until "Done !!" appears before you exit! \n'

else
	EXIT=$?
	>&2 echo ' An error has occured!'
	exit $EXIT
fi

# Sync the buffer to be sure data is on disk
sync
echo ' Done !!' 
