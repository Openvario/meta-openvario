#!/bin/sh
#
# System backup transfer script to usbstick for OpenVario and XCSoar
# 7lima & Blaubart, 2022-06-19
#
# This backup script stores all XCSoar settings and relevant OpenVario settings like:
#
# -brightness of the display
# -rotation
# -Touch screen calibration
# -language settings
# -dropbear settings
# -SSH, variod and sensord status
# 
# backups are stored at USB stick at:
# openvario/backup/"MAC address of eth0

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick
# Backup path on the USB stick
BACKUP=openvario/backup
# MAC address of the Ethernet device eth0 to restore the separate backup
MAC=`ip li|grep -A 1 eth0|tail -n 1|cut -d ' ' -f 6|sed -e s/:/-/g`

echo ' Starting restore ...'
echo ' Wait until "DONE !!" appears before you exit!'

if 
# Copy all files and dirs recursively.
# We use -c here due to cubieboards not having an rtc clock
	rsync --recursive --mkpath --checksum --quiet "$USB_PATH/$BACKUP/$MAC"/ /
	RSYNC_EXIT=$?
# Sync the buffer to be sure data is on disk
	sync
	test $RSYNC_EXIT -eq 0
then
	echo ' All files have been restored.'
else 
	echo " An error $RSYNC_EXIT has occurred!"
	echo ' DONE !!' 
	exit $RSYNC_EXIT
fi

# Restore SSH status 
case `cat /home/root/ssh-status` in
enabled)
	/bin/systemctl enable  --quiet --now dropbear.socket
	echo " SSH has been enabled permanently.";;
temporary)
	/bin/systemctl disable --quiet --now dropbear.socket
	/bin/systemctl start   --quiet --now dropbear.socket
	echo " SSH has been enabled temporarily.";;
disabled)
	/bin/systemctl disable --quiet --now dropbear.socket
	echo " SSH has been disabled.";;
esac

# Restore variod and sensord status 
for DAEMON in variod sensord
do
	case `cat /home/root/$DAEMON-status` in
	enabled)	/bin/systemctl  enable --quiet --now $DAEMON
			echo " $DAEMON has been enabled.";;
	disabled)	/bin/systemctl disable --quiet --now $DAEMON
			echo " $DAEMON has been disabled.";;
	esac
done

# Restore brightness setting
cat /home/root/brightness > /sys/class/backlight/lcd/brightness
echo " brightness setting has been restored."

echo ' DONE !!' 
exit 0
