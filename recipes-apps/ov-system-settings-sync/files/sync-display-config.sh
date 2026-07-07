#!/bin/sh

BOOT_CONFIG=${BOOT_CONFIG:-/boot/config.uEnv}
BRIGHTNESS_PATH=${BRIGHTNESS_PATH:-/sys/class/backlight/lcd/brightness}
ROTATE_PATH=${ROTATE_PATH:-/sys/class/graphics/fbcon/rotate}

read_unsigned_file() {
  [ -r "$1" ] || return 1

  value=$(tr -d '[:space:]' < "$1")
  case "$value" in
    ''|*[!0-9]*)
      return 1
      ;;
  esac

  printf '%s\n' "$value"
}

brightness=$(read_unsigned_file "$BRIGHTNESS_PATH" 2>/dev/null || true)
# rotate_all is write-only; rotate reports the active console's state.
rotation=$(read_unsigned_file "$ROTATE_PATH" 2>/dev/null || true)
case "$rotation" in
  0|1|2|3) ;;
  *) rotation= ;;
esac

[ -n "$brightness" ] || [ -n "$rotation" ] || exit 0

tmp=$(mktemp "${BOOT_CONFIG}.tmp.XXXXXX") || exit 1
trap 'rm -f "$tmp"' 0 HUP INT TERM

input=/dev/null
[ -f "$BOOT_CONFIG" ] && input=$BOOT_CONFIG

awk -F= -v brightness="$brightness" -v rotation="$rotation" '
  BEGIN {
    keys[1] = "brightness"
    keys[2] = "rotation"
    values["brightness"] = brightness
    values["rotation"] = rotation
  }
  index($0, "=") && ($1 in values) && values[$1] != "" {
    print $1 "=" values[$1]
    seen[$1] = 1
    next
  }
  { print }
  END {
    for (i = 1; i <= 2; i++)
      if (values[keys[i]] != "" && !seen[keys[i]])
        print keys[i] "=" values[keys[i]]
  }
' "$input" > "$tmp" || exit 1

printf '%s\n' 'Saving display settings...'
mv "$tmp" "$BOOT_CONFIG"
