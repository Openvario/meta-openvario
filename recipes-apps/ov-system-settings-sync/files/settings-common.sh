#!/bin/sh
# SPDX-License-Identifier: MIT

# shellcheck source=/dev/null
. "${OV_PATHS:-/usr/libexec/openvario/paths.sh}" || return 1
MOUNTPOINT_CMD=${OV_MOUNTPOINT:-/bin/mountpoint}


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
