#!/bin/sh
# SPDX-License-Identifier: MIT

# shellcheck source=/dev/null
. "${OV_PATHS:-/usr/libexec/openvario/paths.sh}" || return 1
MOUNTPOINT_CMD=${OV_MOUNTPOINT:-/bin/mountpoint}

: "${BOOT_CONFIG_CMD:=/usr/libexec/openvario/boot-config}"

ov_require_data_mount() {
  if ! "$MOUNTPOINT_CMD" -q "$DATA_DIR"; then
    echo "Persistent data is not mounted at $DATA_DIR." >&2
    return 1
  fi
}

ov_read_trimmed_file() {
  [ -r "$1" ] || return 1
  tr -d '[:space:]' < "$1"
}

ov_read_unsigned_file() {
  value=$(ov_read_trimmed_file "$1") || return 1
  case $value in
    ''|*[!0-9]*) return 1 ;;
  esac
  printf '%s\n' "$value"
}

ov_read_rotation_file() {
  value=$(ov_read_unsigned_file "$1") || return 1
  case $value in
    0|1|2|3) printf '%s\n' "$value" ;;
    *) return 1 ;;
  esac
}

ov_normalize_application() {
  case $1 in
    OpenSoar) printf '%s\n' OpenSoar ;;
    xcsoar|XCSoar) printf '%s\n' xcsoar ;;
    *) return 1 ;;
  esac
}

ov_read_application_file() {
  value=$(ov_read_trimmed_file "$1") || return 1
  ov_normalize_application "$value"
}

ov_write_state() {
  destination=$1
  value=$2
  directory=$(dirname "$destination")
  settings_directory=$SETTINGS_DIR

  mkdir -p "$directory" || return 1
  chmod 0700 "$settings_directory" "$directory" || return 1

  if [ -r "$destination" ] &&
     [ "$(ov_read_trimmed_file "$destination")" = "$value" ]; then
    return 0
  fi

  temporary=$(mktemp "${destination}.tmp.XXXXXX") || return 1
  if ! printf '%s\n' "$value" > "$temporary" ||
     ! chmod 0600 "$temporary" ||
     ! mv "$temporary" "$destination"; then
    rm -f "$temporary"
    return 1
  fi
}
