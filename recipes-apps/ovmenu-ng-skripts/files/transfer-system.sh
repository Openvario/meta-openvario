#!/bin/sh
#
# transfer-xcsoar.sh
# Legacy system backup transfer to USB for OpenVario and XCSoar
#
# Created by lordfolken         2022-02-08
# Enhanced by 7lima & Blaubart  2022-06-19
#
# This backup script stores all XCSoar settings and relevant
# Openvario settings like:
#
# -brightness of the display
# -rotation
# -touch screen calibration
# -language settings
# -dropbear settings
# -SSH, variod and sensord status
# 
# backups are stored at USB stick at:
# openvario/backup/<MAC address of eth0>/
# So you can store backups from more than one OV on the same stick!

# shortcut: refuse legacy restores until a persistent-state importer exists.
if [ "${1:-}" = restore ]; then
	printf '%s\n' 'Legacy system restore is unavailable with persistent settings.' \
		'No files were changed.' >&2
	exit 1
fi

echo ' [==========] Starting'
echo ' [#=========] Wait until "DONE !!" appears before you exit!'

# Provident background system buffer sync to help later syncs finish quicker
sync&

TRANSFER_OPTION=$1

# Path where the USB stick is mounted
USB_PATH=/usb/usbstick

# XCSoar settings path
export XCSOAR_PATH=/home/root/.xcsoar

# Backup path within the USB stick
BACKUP=openvario/backup

# MAC address of the Ethernet device eth0 to do a separate backup
MAC=`ip li|grep -A 1 eth0|tail -n 1|cut -d ' ' -f 6|sed -e s/:/-/g`

case "$TRANSFER_OPTION" in
backup)
	echo ' [##========] System check ...'
	
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
	
	# Store if profiles are protected or not
	if command -v lsattr >/dev/null 2>&1;
	then
	PROFILE= find "$XCSOAR_PATH" -maxdepth 1 -type f -name '*.prf' -exec sh -c '
	for PROFILE; 
	do
		mkdir -p /home/root/profile-settings
		PROFILE_FILE=`basename "$PROFILE"`
		PROFILE_NAME=${PROFILE_FILE%.*}
		if command -v lsattr >/dev/null 2>&1; then
			if lsattr "$PROFILE" | cut -b 5 | fgrep -q i; 
			then echo protected
			else echo unprotected
			fi > /home/root/profile-settings/$PROFILE_NAME 
		else
			echo 'lsattr' is NOT available
		fi
	done
	' -- {} +
	fi

	# Copy brightness setting
	cat /sys/class/backlight/lcd/brightness > /home/root/brightness

	echo ' [####======] Starting backup ...'
	# Copy all directories and files from list below to backup directory recursively.
	# We use --checksum here due to cubieboards not having an rtc clock
        if [ -f /etc/udev/rules.d/libinput-ts.rules ]; then LIBINPUT_RULES="/etc/udev/rules.d/libinput-ts.rules"; fi
	if 
		rsync --files-from - --archive --recursive --quiet \
			--relative --mkpath --checksum --safe-links --progress \
			/ "$USB_PATH/$BACKUP/$MAC"/ <<-LISTE
				/etc/dropbear
				/home/root
				/opt/conf
				/var/lib/connman
				/boot/config.uEnv
				$LIBINPUT_RULES
			LISTE
		test ${RSYNC_EXIT:=$?} -eq 0
	then
		echo ' [######====] All files and settings have been backed up.'
	else 
		>&2 echo " An rsync error $RSYNC_EXIT has occurred!"
	fi;;
	
*)
	>&2 echo "not valid calling parameter: $TRANSFER_OPTION"
	exit 1;;
esac

# Sync the system buffer to make sure all data is on disk
echo ' [#########=] Please wait a moment, synchronization is not yet complete!'
sync
echo ' [##########] DONE !! ---------------------------------------------------'
exit $RSYNC_EXIT
