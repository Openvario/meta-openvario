#!/bin/sh
#
# System backup transfer script to usbstick for OpenVario and XCSoar
#
# 7lima & Blaubart, 2022-06-19
#
# This backup and restore script stores all XCSoar settings and relevant OpenVario settings like:
#
# -brightness of the display
# -rotation
# -Touch screen calibration
# -language settings
# -dropbear settings
# -SSH, variod and sensord status
# 
# backups are stored at USB stick at:
# openvario/backup/"MAC address of eth0"/
#
# So you can store more than one backup on the same stick!

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick

# Backup path on the USB stick
BACKUP=openvario/backup

# MAC address of the Ethernet device eth0 to do a separate backup
MAC=`ip li|grep -A 1 eth0|tail -n 1|cut -d ' ' -f 6|sed -e s/:/-/g`

case "$(basename "$0")" in
	'backup-system.sh')
		# Store SSH status 
		if   /bin/systemctl --quiet is-enabled dropbear.socket
		then	echo enabled
		elif /bin/systemctl --quiet is-active  dropbear.socket
		then	echo temporary
		else	echo disabled  
		fi > /home/root/ssh-status

		# Store variod and sensord status
		for DAEMON in variod sensord
		do
			if /bin/systemctl --quiet is-enabled $DAEMON
			then echo  enabled
			else echo disabled  
			fi > /home/root/$DAEMON-status
		done

		# Copy brightness setting
		cat /sys/class/backlight/lcd/brightness > /home/root/brightness

		# Copy all directories and files from list to backup directory recursively
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
			echo ' Starting backup ...'
			echo ' Wait until "DONE !!" appears before you exit!'
			rsync --files-from - --archive --recursive --quiet --relative --mkpath \
			      --checksum --safe-links \
			      / "$USB_PATH/$BACKUP/$MAC"/
			RSYNC_EXIT=$?
		# Sync the system buffer to be sure data is on disk
			sync
			test $RSYNC_EXIT -eq 0
		then
			echo ' All files and some settings have been backed up.'
			echo ' DONE !!'
			exit 0
		else 
			echo ' An error has occurred!'
			echo ' Copying using rsync issued error code' $RSYNC_EXIT
			echo ' DONE !!'
			exit $RSYNC_EXIT
		fi
		;;
	'restore-xcsoar.sh')
		echo ' Starting restore of XCSoar...'
		echo ' Wait until "DONE !!" appears before you exit!'

		if 
		# Copy all files and dirs recursively.
		# We use -c here due to cubieboards not having an rtc clock
			rsync --recursive --mkpath --checksum --quiet "$USB_PATH/$BACKUP/$MAC"/home/root/.xcsoar/ /home/root/.xcsoar
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
		;;
	'restore-system.sh')
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
		;;
	*)
		>&2 echo 'call as download-all.sh, upload-xcsoar.sh or upload-all.sh'
		exit 1
esac

