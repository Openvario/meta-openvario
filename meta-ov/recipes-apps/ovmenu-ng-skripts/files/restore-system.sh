#!/bin/sh
#
# Transfer script for OpenVario backup to usbstick
# 7lima, 2022-06-19

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick/openvario/backup

# MAC address of the Ethernet device eth0 to restore the separate backup
MAC=`ip li|fgrep -A 1 eth0|head -n 2|cut -d ' ' -f 6|tail -n 1|sed -e s/:/-/g`

# Restore SSH-status 
SSH=$(cat $USB_PATH/$MAC/home/root/ssh-status)
if [ "$SSH" = "enabled" ]; then
	echo " SSH has been enabled permanently."
	/bin/systemctl enable --quiet  --now dropbear.socket
	
elif [ "$SSH" = "temporary" ]; then
	echo " SSH has been enabled temporarily."
	/bin/systemctl disable dropbear.socket
	/bin/systemctl start dropbear.socket
	
elif [ "$SSH" = "disabled" ]; then
	echo " SSH has been disabled."
	/bin/systemctl disable --quiet --now dropbear.socket
fi

# Restore brightness setting
cat $USB_PATH/$MAC/home/root/brightness >> /sys/class/backlight/lcd/brightness

# We use -c here due to cubieboards not having an rtc clock
if rsync -r -c --progress --quiet "$USB_PATH/$MAC/" /; then
	echo -e ' All files have been restored. \n Wait until "Done !!" appears before you exit! \n'
else
	EXIT=$?
	>&2 echo ' An error has occured!'
	exit $EXIT
fi

# Sync the buffer to be sure data is on disk
sync
echo ' Done !!'
