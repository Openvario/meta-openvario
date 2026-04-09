#!/bin/bash
# ov-system-init.sh - One-shot system initialization for OpenVario
#
# Sets display brightness, restores configuration after firmware upgrade,
# and ensures the data partition (mmcblk0p3) is created and mounted.
#
# All operations are idempotent - safe to run if the system is already
# initialized.

HOME=/home/root
DATADIR=$HOME/data
RECOVER_DIR=$HOME/recover_data
BOOT_CONFIG=/boot/config.uEnv

# --- Logging: keep previous boot's log, start fresh ---
OV_LOGFILE="$HOME/ov-system-init.log"
cp -f "$OV_LOGFILE" "${OV_LOGFILE}.prev" 2>/dev/null
exec > >(while IFS= read -r line; do
	printf '%(%H:%M:%S)T %s\n' -1 "$line"
done | tee "$OV_LOGFILE") 2>&1

# --- Load boot configuration ---
if [ -f "$BOOT_CONFIG" ]; then
	# shellcheck source=/dev/null
	source "$BOOT_CONFIG"
fi

# --- Set display brightness ---
brightness="${brightness:-10}"
if [ -w /sys/class/backlight/lcd/brightness ]; then
	echo "$brightness" > /sys/class/backlight/lcd/brightness
	echo "Brightness set to $brightness"
fi

# --- Post-upgrade config restore ---
if [ -f "$RECOVER_DIR/upgrade.cfg" ]; then
	echo "Restoring system configuration after upgrade"
	# update-system-config.sh uses DATADIR without defining it
	export HOME DATADIR
	/usr/bin/update-system-config.sh
elif [ ! -f "$RECOVER_DIR/_upgrade.cfg" ]; then
	echo "No upgrade configuration found"
fi

# --- Create data partition if it does not exist ---
if [ ! -e /dev/mmcblk0p3 ]; then
	echo "Creating data partition (mmcblk0p3)"
	/usr/bin/create_datapart.sh

	if [ ! -e /dev/mmcblk0p3 ]; then
		echo "Partition not yet visible, rebooting for kernel to pick up new table"
		sync
		reboot
		sleep 60
	fi
fi

# --- Mount data partition ---
mkdir -p "$DATADIR"

if ! mountpoint -q "$DATADIR"; then
	if ! mount /dev/mmcblk0p3 "$DATADIR"; then
		echo "Mount failed, formatting partition" >&2
		mkfs.ext4 -F /dev/mmcblk0p3 || echo "Failed to format mmcblk0p3" >&2
		mount /dev/mmcblk0p3 "$DATADIR" || echo "Failed to mount mmcblk0p3" >&2
	fi
fi

if mountpoint -q "$DATADIR"; then
	echo "Data partition mounted at $DATADIR"
	mkdir -p "$DATADIR/OpenSoarData" "$DATADIR/XCSoarData"
else
	echo "WARNING: Data partition could not be mounted" >&2
fi

echo "System initialization complete"
