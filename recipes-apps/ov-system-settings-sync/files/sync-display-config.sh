#!/bin/sh

BOOT_CONFIG=${BOOT_CONFIG:-/boot/config.uEnv}
BRIGHTNESS_PATH=${BRIGHTNESS_PATH:-/sys/class/backlight/lcd/brightness}
ROTATE_PATH=${ROTATE_PATH:-/sys/class/graphics/fbcon/rotate}
VTCONSOLE_PATH=${VTCONSOLE_PATH:-/sys/class/vtconsole}

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

brightness=$(read_unsigned_file "$BRIGHTNESS_PATH" 2>/dev/null || true)
# An unbound fbcon can report zero instead of the configured rotation.
rotation=
if framebuffer_bound; then
  rotation=$(read_unsigned_file "$ROTATE_PATH" 2>/dev/null || true)
  case "$rotation" in
    0|1|2|3) ;;
    *) rotation= ;;
  esac
fi

[ -n "$brightness" ] || [ -n "$rotation" ] || exit 0

input=/dev/null
[ -f "$BOOT_CONFIG" ] && input=$BOOT_CONFIG

render_config() {
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
' "$input"
}

# Compare before creating a temporary file on the boot partition.
if [ -f "$BOOT_CONFIG" ] && render_config | cmp -s "$BOOT_CONFIG" -; then
  exit 0
fi

tmp=$(mktemp "${BOOT_CONFIG}.tmp.XXXXXX") || exit 1
trap 'rm -f "$tmp"' 0 HUP INT TERM
render_config > "$tmp" || exit 1

mv "$tmp" "$BOOT_CONFIG"
