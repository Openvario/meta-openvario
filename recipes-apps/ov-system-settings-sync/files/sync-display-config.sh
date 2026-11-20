#!/bin/sh

SETTINGS_COMMON=${SETTINGS_COMMON:-/usr/libexec/openvario/settings-common.sh}

# shellcheck source=/dev/null
. "$SETTINGS_COMMON" || exit 1

BRIGHTNESS_SYSFS_FILE=${BRIGHTNESS_SYSFS_FILE:-/sys/class/backlight/lcd/brightness}
ROTATION_SYSFS_FILE=${ROTATION_SYSFS_FILE:-/sys/class/graphics/fbcon/rotate}
VTCONSOLE_PATH=${VTCONSOLE_PATH:-/sys/class/vtconsole}

framebuffer_bound() {
  for console in "$VTCONSOLE_PATH"/vtcon*; do
    [ -r "$console/name" ] && [ -r "$console/bind" ] || continue
    case "$(cat "$console/name")" in
      *'frame buffer device'*)
        [ "$(cat "$console/bind")" = 1 ] && return 0
        ;;
    esac
  done
  return 1
}

brightness=$(ov_read_unsigned_file "$BRIGHTNESS_SYSFS_FILE" 2>/dev/null || true)
# An unbound fbcon can report zero instead of the configured rotation.
rotation=
if framebuffer_bound; then
  rotation=$(ov_read_rotation_file "$ROTATION_SYSFS_FILE" 2>/dev/null || true)
fi

[ -n "$brightness" ] || [ -n "$rotation" ] || exit 0

ov_require_data_mount || exit 1

if [ -n "$brightness" ]; then
  ov_write_state "$BRIGHTNESS_FILE" "$brightness" || exit 1
fi
if [ -n "$rotation" ]; then
  ov_write_state "$ROTATION_FILE" "$rotation" || exit 1
fi

printf '%s\n' 'Saving display settings...'
DATA_DIR="$DATA_DIR" OV_MOUNTPOINT="$MOUNTPOINT_CMD" \
BRIGHTNESS_FILE="$BRIGHTNESS_FILE" ROTATION_FILE="$ROTATION_FILE" \
BOOT_CONFIG_FILE="$BOOT_CONFIG_FILE" \
SETTINGS_COMMON="$SETTINGS_COMMON" "$BOOT_CONFIG_CMD" project
