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
USB_MOUNTPOINT=/usb/usbstick

/usr/bin/psplash-message "Preparing OpenVario..." 2>/dev/null || true

is_path_mounted() {
	awk -v target="$1" '
		$2 == target && $3 != "autofs" { mounted = 1 }
		END { exit !mounted }
	' /proc/self/mounts
}

# --- USB debug hook for field diagnostics ---
# Source a script from a USB stick if present. This allows in-field
# debugging on an embedded device where SSH / serial is unavailable.
# The script is sourced (not copied), so nothing persists after USB removal.
if is_path_mounted "$USB_MOUNTPOINT" && [ -f "$USB_DEBUG_HOOK" ]; then
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
	/usr/bin/psplash-message "Restoring configuration..." 2>/dev/null || true
	echo "Update system config"
	export HOME DEBUG_LOG
	DATADIR="$DATADIR" /usr/bin/update-system-config.sh
elif [ ! -f "$RECOVER_DIR/_upgrade.cfg" ]; then
	echo "upgrade.cfg not found"
else
	echo "only backup config found"
fi

storage_failed() {
	/usr/bin/psplash-message "Data storage setup failed" 2>/dev/null || true
	echo "$1" >&2
	exit 1
}

# --- Create data partition if it does not exist ---
if [ ! -e /dev/mmcblk0p3 ]; then
	/usr/bin/psplash-message "Preparing data storage..." 2>/dev/null || true
	echo "Creating data partition (mmcblk0p3)"
	# A missing device node does not prove the partition is absent on disk.
	partitions=$(/usr/sbin/partx --raw --noheadings --output NR /dev/mmcblk0) ||
		storage_failed "Cannot read the data partition table"
	if ! printf '%s\n' "$partitions" | grep -qx '3'; then
		/usr/bin/create_datapart.sh
	fi
	# Re-reading the complete table usually fails while the root partition is
	# mounted. Ask the kernel to add only the new partition first.
	/usr/sbin/partx --add --nr 3 /dev/mmcblk0 2>/dev/null || true
	/usr/bin/udevadm settle --exit-if-exists=/dev/mmcblk0p3 --timeout=30 2>/dev/null || true

	if [ ! -e /dev/mmcblk0p3 ]; then
		/usr/bin/psplash-message "Restarting to finish setup..." 2>/dev/null || true
		echo "Partition not yet visible, rebooting for kernel to pick up new table"
		sync
		reboot
		sleep 60
		storage_failed "Data partition still unavailable after requesting reboot"
	fi
fi

# --- Mount data partition ---
mkdir -p "$DATADIR"

if ! mountpoint -q "$DATADIR"; then
	/usr/bin/psplash-message "Opening data storage..." 2>/dev/null || true
	if ! mount /dev/mmcblk0p3 "$DATADIR"; then
		# Try the repair tool when already installed; do not add a package
		# solely for this temporary startup recovery policy.
		if command -v e2fsck >/dev/null 2>&1; then
			/usr/bin/psplash-message "Repairing data storage..." 2>/dev/null || true
			e2fsck -p /dev/mmcblk0p3 || true
		fi
		if ! mount /dev/mmcblk0p3 "$DATADIR"; then
			# Availability takes priority here. A failed repair/mount can
			# erase existing data; backups must live outside this partition.
			/usr/bin/psplash-message "Formatting data storage..." 2>/dev/null || true
			echo "Cannot mount data storage; formatting mmcblk0p3" >&2
			mkfs.ext4 -F /dev/mmcblk0p3 || storage_failed "Failed to format mmcblk0p3"
			mount /dev/mmcblk0p3 "$DATADIR" || storage_failed "Failed to mount mmcblk0p3"
		fi
	fi
fi

# Prepare application data directories after storage recovery.
mkdir -p "$DATADIR/OpenSoarData" "$DATADIR/XCSoarData" ||
    storage_failed "Cannot initialize application data directories"

exit 0
