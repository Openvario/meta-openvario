#!/bin/sh
#
# System backup transfer script to usbstick for OpenVario
# 7lima & Blaubart, 2022-06-19

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick
# Backup path on the USB stick
BACKUP=openvario/backup
# MAC address of the Ethernet device eth0 to do a separate backup
MAC=`ip li|fgrep -A 1 eth0|tail -n 1|cut -d ' ' -f 6|sed -e s/:/-/g`

# Store SSH-status 
if   /bin/systemctl --quiet is-enabled dropbear.socket; then
	echo enabled
elif /bin/systemctl --quiet is-active  dropbear.socket; then
	echo temporary
else 
	echo disabled  
fi > /home/root/ssh-status

# Store variod-status 
if   /bin/systemctl --quiet is-enabled variod; then
	echo enabled
else 
	echo disabled  
fi > /home/root/variod-status

# Store sensord-status 
if   /bin/systemctl --quiet is-enabled sensord; then
	echo enabled
else 
	echo disabled  
fi > /home/root/sensord-status

# Copy brightness setting
cat /sys/class/backlight/lcd/brightness > /home/root/brightness

# Copy all directories and files from list below to backup directory
echo "
/etc/locale.conf
/etc/udev/rules.d/libinput-ts.rules
/etc/pointercal
/etc/dropbear
/etc/opkg
/home/root
/opt/conf
/var/lib/connman
/boot/config.uEnv
" |
if 
# Copy all files and dirs recursively
	echo ' Starting backup ...'
	echo ' Wait until "Done !!" appears before you exit!'
	rsync --files-from - --archive --recursive --quiet --relative --mkpath --checksum --safe-links \
		/ "$USB_PATH/$BACKUP/$MAC"/
	EXIT=$?
# Sync the buffer to be sure data is on disk
	sync
	test $EXIT -eq 0
then
	echo ' All files and some settings have been backed up.'
else 
	echo ' An error has occurred!'
	echo ' Copying using rsync issued error code' $EXIT
fi

echo ' Done !!' 
exit $EXIT
