#!/bin/bash
# ov-system-init.sh - Startup preparation after psplash and before menu
#
# Sets display brightness, restores configuration after firmware upgrade,
# and ensures the data partition (mmcblk0p3) is created and mounted.
#
# All operations are idempotent - safe to run if the system is already
# initialized.
# Keep this script free of extra file logging because it runs during the
# psplash-to-menu handover on Cubieboard2.

HOME=/home/root
DATADIR=$HOME/data
DEBUG_LOG=$HOME/start-debug.log
RECOVER_DIR=$HOME/recover_data
USB_DEBUG_HOOK=/usb/usbstick/openvario/ov-debug-hook.sh
BOOT_CONFIG=/boot/config.uEnv

# --- USB debug hook for field diagnostics ---
# Source a script from a USB stick if present. This allows in-field
# debugging on an embedded device where SSH / serial is unavailable.
# The script is sourced (not copied), so nothing persists after USB removal.
if [ -f "$USB_DEBUG_HOOK" ]; then
	echo "WARNING: executing USB debug hook from $USB_DEBUG_HOOK"
	# shellcheck source=/dev/null
	source "$USB_DEBUG_HOOK"
fi

# --- Load boot configuration ---
if [ -f "$BOOT_CONFIG" ]; then
	# shellcheck source=/dev/null
	source "$BOOT_CONFIG"
fi

# --- Set display brightness ---
if [ -w /sys/class/backlight/lcd/brightness ]; then
	echo "${brightness:-10}" > /sys/class/backlight/lcd/brightness
fi

cd "$HOME"

# --- Post-upgrade config restore ---
if [ -f "$RECOVER_DIR/upgrade.cfg" ]; then
	echo "Update system config"
	export HOME DEBUG_LOG
	DATADIR="$DATADIR" /usr/bin/update-system-config.sh
elif [ ! -f "$RECOVER_DIR/_upgrade.cfg" ]; then
	echo "upgrade.cfg not found"
else
	echo "only backup config found"
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
	mkdir -p "$DATADIR/OpenSoarData" "$DATADIR/XCSoarData"
fi

exit 0
