#!/bin/sh
#
# System restore transfer script from usbstick for OpenVario
# 7lima & Blaubart, 2022-06-19

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
	echo ' An error $EXIT has occurred!'
	echo ' Done !!' 
	exit $EXIT
fi

# Restore SSH-status 
case `cat /home/root/ssh-status` in
enabled)
	/bin/systemctl enable  --quiet --now dropbear.socket;;
	echo " SSH has been enabled permanently."
temporary)
	/bin/systemctl disable --quiet --now dropbear.socket
	/bin/systemctl start   --quiet --now dropbear.socket;;
	echo " SSH has been enabled temporarily."
disabled)
	/bin/systemctl disable --quiet --now dropbear.socket;;
	echo " SSH has been disabled."
esac

# Restore variod status 
case `cat /home/root/variod-status` in
enabled)
	/bin/systemctl enable  --quiet --now variod;;
	echo " variod has been enabled."
disabled)
	/bin/systemctl disable --quiet --now variod;;
	echo " variod has been disabled."
esac

# Restore sensord status 
case `cat /home/root/sensord-status` in
enabled)
	/bin/systemctl enable  --quiet --now sensord;;
	echo " sensord has been enabled."
disabled)
	/bin/systemctl disable --quiet --now sensord;;
	echo " sensord has been disabled."
esac

# Restore brightness setting
cat /home/root/brightness > /sys/class/backlight/lcd/brightness
echo " brightness setting has been restored."

echo ' Done !!' 
exit 0
