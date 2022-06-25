#!/bin/sh
#
# Transfer script for OpenVario backup to usbstick
# 7lima, 2022-06-19

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick/openvario/backup

# MAC address of the Ethernet device eth0 to restore the separate backup
MAC=`ip li|fgrep -A 1 eth0|tail -n 1|cut -d ' ' -f 6|sed -e s/:/-/g`

# Restore SSH-status 
SSH=`cat $USB_PATH/$MAC/home/root/ssh-status`
if [ "$SSH" = enabled ]; then
	echo " SSH has been enabled permanently."
	/bin/systemctl enable  --quiet --now dropbear.socket
	
elif [ "$SSH" = temporary ]; then
	echo " SSH has been enabled temporarily."
	/bin/systemctl disable dropbear.socket
	/bin/systemctl start   dropbear.socket
	
elif [ "$SSH" = disabled ]; then
	echo " SSH has been disabled."
	/bin/systemctl disable --quiet --now dropbear.socket
fi

# Restore variod-status 
variod=`cat $USB_PATH/$MAC/home/root/variod-status`
if [ "$variod" = enabled ]; then
	echo " variod has been enabled."
	/bin/systemctl enable  --quiet --now variod
elif [ "$variod" = disabled ]; then
	echo " variod has been disabled."
	/bin/systemctl disable --quiet --now variod
fi

# Restore sensord-status 
sensord=`cat $USB_PATH/$MAC/home/root/sensord-status`
if [ "$sensord" = enabled ]; then
	echo " sensord has been enabled."
	/bin/systemctl enable  --quiet --now sensord
elif [ "$sensord" = disabled ]; then
	echo " sensord has been disabled."
	/bin/systemctl disable --quiet --now sensord
fi

# Restore brightness setting
cat $USB_PATH/$MAC/home/root/brightness > /sys/class/backlight/lcd/brightness

if 
# Copy all files and dirs recursively.
# We use -c here due to cubieboards not having an rtc clock
	echo ' Starting backup ...'
	echo ' Wait until "Done !!" appears before you exit!'
	rsync --recursive --mkpath --checksum --quiet "$USB_PATH/$MAC/" /
	EXIT=$?
# Sync the buffer to be sure data is on disk
	sync
	test $EXIT -eq 0
then
	echo ' All files have been restored.'
else 
	echo ' An error has occured!'
fi

echo ' Done !!' 
exit $EXIT
