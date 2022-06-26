#!/bin/sh
#
# System restore transfer script from usbstick for OpenVario
# 7lima, 2022-06-19

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick
# Backup path on the USB stick
BACKUP=openvario/backup
# MAC address of the Ethernet device eth0 to restore the separate backup
MAC=`ip li|fgrep -A 1 eth0|tail -n 1|cut -d ' ' -f 6|sed -e s/:/-/g`

if 
# Copy all files and dirs recursively.
# We use -c here due to cubieboards not having an rtc clock
	echo ' Starting restore ...'
	echo ' Wait until "Done !!" appears before you exit!'
	rsync --recursive --mkpath --checksum --quiet "$USB_PATH/$BACKUP/$MAC"/ /
	EXIT=$?
# Sync the buffer to be sure data is on disk
	sync
	test $EXIT -eq 0
then
	echo ' All files have been restored.'
else 
	echo ' An error has occured!'
	echo ' Copying using rsync issued error code' $EXIT
fi

# Restore SSH-status 
case `cat /home/root/ssh-status` in
enabled)
	echo " SSH has been enabled permanently."
	/bin/systemctl enable  --quiet --now dropbear.socket;;
temporary)
	echo " SSH has been enabled temporarily."
	/bin/systemctl disable dropbear.socket
	/bin/systemctl start   dropbear.socket;;
disabled)
	echo " SSH has been disabled."
	/bin/systemctl disable --quiet --now dropbear.socket;;
esac

# Restore variod status 
case `cat /home/root/variod-status` in
enabled)
	echo " variod has been enabled."
	/bin/systemctl enable  --quiet --now variod;;
disabled)
	echo " variod has been disabled."
	/bin/systemctl disable --quiet --now variod;;
esac

# Restore sensord status 
case `cat /home/root/sensord-status` in
enabled)
	echo " sensord has been enabled."
	/bin/systemctl enable  --quiet --now sensord;;
disabled)
	echo " sensord has been disabled."
	/bin/systemctl disable --quiet --now sensord;;
esac

# Restore brightness setting
cat /home/root/brightness > /sys/class/backlight/lcd/brightness

echo ' Done !!' 
exit $EXIT
