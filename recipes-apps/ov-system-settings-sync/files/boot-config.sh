#!/bin/sh
# SPDX-License-Identifier: MIT

SETTINGS_COMMON=${SETTINGS_COMMON:-/usr/libexec/openvario/settings-common.sh}

# shellcheck source=/dev/null
. "$SETTINGS_COMMON" || exit 1


render_boot_config() {
  awk -F= -v brightness="$brightness" -v rotation="$rotation" -v main_app="$main_app" '
      BEGIN {
        keys[1] = "brightness"
        values["brightness"] = brightness
        keys[2] = "rotation"
        values["rotation"] = rotation
        keys[3] = "main_app"
        values["main_app"] = main_app
      }
      ($1 in values) && values[$1] != "" {
        if (!seen[$1]) print $1 "=" values[$1]
        seen[$1] = 1
        next
      }
      { print }
      END {
        for (i = 1; i <= 3; i++)
          if (values[keys[i]] != "" && !seen[keys[i]])
            print keys[i] "=" values[keys[i]]
      }
    ' "$input"
}

project_boot_config() {
  ov_require_data_mount || return 1

  brightness=
  rotation=
  main_app=

  if [ -e "$BRIGHTNESS_FILE" ]; then
    brightness=$(ov_read_unsigned_file "$BRIGHTNESS_FILE") || {
      echo "Persistent display brightness is invalid." >&2
      return 1
    }
  fi

  if [ -e "$ROTATION_FILE" ]; then
    rotation=$(ov_read_rotation_file "$ROTATION_FILE") || {
      echo "Persistent display rotation is invalid." >&2
      return 1
    }
  fi

  if [ -e "$MAIN_APP_FILE" ]; then
    main_app=$(ov_read_application_file "$MAIN_APP_FILE") || {
      echo "Persistent application selection is invalid." >&2
      return 1
    }
  fi

  [ -n "$brightness" ] ||
    [ -n "$rotation" ] ||
    [ -n "$main_app" ] || return 0

  input=/dev/null
  [ -f "$BOOT_CONFIG_FILE" ] && input=$BOOT_CONFIG_FILE
  # Compare before creating a temporary file on the boot partition.
  if [ -f "$BOOT_CONFIG_FILE" ] && render_boot_config | cmp -s "$BOOT_CONFIG_FILE" -; then
    return 0
  fi

  temporary=$(mktemp "${BOOT_CONFIG_FILE}.tmp.XXXXXX") || return 1
  trap 'rm -f "$temporary"' HUP INT TERM EXIT
  if ! render_boot_config > "$temporary" || ! mv "$temporary" "$BOOT_CONFIG_FILE"; then
    return 1
  fi

  trap - HUP INT TERM EXIT
}

if [ "$#" -ne 1 ] || [ "$1" != project ]; then
  echo "Usage: $0 project" >&2
  exit 2
fi

project_boot_config
