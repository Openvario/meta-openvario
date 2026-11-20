#!/bin/sh
# SPDX-License-Identifier: MIT

SETTINGS_COMMON=${SETTINGS_COMMON:-/usr/libexec/openvario/settings-common.sh}

# shellcheck source=/dev/null
. "$SETTINGS_COMMON" || exit 1

BRIGHTNESS_SYSFS_FILE=${BRIGHTNESS_SYSFS_FILE:-/sys/class/backlight/lcd/brightness}
ROTATION_SYSFS_FILE=${ROTATION_SYSFS_FILE:-/sys/class/graphics/fbcon/rotate}
ROTATION_ALL_SYSFS_FILE=${ROTATION_ALL_SYSFS_FILE:-/sys/class/graphics/fbcon/rotate_all}
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

if [ -e "$ROTATION_FILE" ]; then
  rotation=$(ov_read_rotation_file "$ROTATION_FILE") || {
    echo "Persistent display rotation is invalid; leaving the display unchanged." >&2
    exit 1
  }
  if [ -w "$ROTATION_ALL_SYSFS_FILE" ]; then
    rotation_target=$ROTATION_ALL_SYSFS_FILE
  elif [ -w "$ROTATION_SYSFS_FILE" ]; then
    rotation_target=$ROTATION_SYSFS_FILE
  else
    echo "The display rotation control is unavailable." >&2
    exit 1
  fi

  if ! printf '%s\n' "$rotation" > "$rotation_target"; then
    echo "Could not restore persistent display rotation." >&2
    exit 1
  fi

  # A successful sysfs write can leave a graphics-mode console unchanged.
  if [ "$(ov_read_unsigned_file "$ROTATION_SYSFS_FILE")" != "$rotation" ]; then
    echo "Persistent display rotation was not applied; retaining saved settings." >&2
    exit 1
  fi
fi

# If no persistent value exists yet, this captures the live/default value.
# Otherwise it verifies the applied value and updates the /boot projection.
exec "$SYNC_DISPLAY_CONFIG"
