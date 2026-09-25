#!/bin/sh
# SPDX-License-Identifier: MIT

SETTINGS_COMMON=${SETTINGS_COMMON:-/usr/libexec/openvario/settings-common.sh}

# shellcheck source=/dev/null
. "$SETTINGS_COMMON" || exit 1

BRIGHTNESS_SYSFS_FILE=${BRIGHTNESS_SYSFS_FILE:-/sys/class/backlight/lcd/brightness}
SYNC_DISPLAY_CONFIG=${SYNC_DISPLAY_CONFIG:-/usr/bin/sync-display-config.sh}

ov_require_data_mount || exit 1

if [ -e "$BRIGHTNESS_FILE" ]; then
  brightness=$(ov_read_unsigned_file "$BRIGHTNESS_FILE") || {
    echo "Persistent display brightness is invalid; leaving the display unchanged." >&2
    exit 1
  }

  if [ ! -w "$BRIGHTNESS_SYSFS_FILE" ] ||
     ! printf '%s\n' "$brightness" > "$BRIGHTNESS_SYSFS_FILE"; then
    echo "Could not restore persistent display brightness." >&2
    exit 1
  fi
fi

# If no persistent value exists yet, this captures the live/default value.
# Otherwise it verifies the applied value and updates the /boot projection.
exec "$SYNC_DISPLAY_CONFIG"
