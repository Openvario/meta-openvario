#!/bin/sh
# SPDX-License-Identifier: MIT

SETTINGS_COMMON=${SETTINGS_COMMON:-/usr/libexec/openvario/settings-common.sh}

# shellcheck source=/dev/null
. "$SETTINGS_COMMON" || exit 1

read_boot_value() {
  [ -r "$BOOT_CONFIG_FILE" ] || return 1
  value=$(awk -F= '$1 == "main_app" { value = $2 } END { print value }' \
    "$BOOT_CONFIG_FILE") || return 1
  ov_normalize_application "$value"
}

project_boot_config() {
  DATA_DIR="$DATA_DIR" OV_MOUNTPOINT="$MOUNTPOINT_CMD" \
  MAIN_APP_FILE="$MAIN_APP_FILE" BOOT_CONFIG_FILE="$BOOT_CONFIG_FILE" \
  SETTINGS_COMMON="$SETTINGS_COMMON" "$BOOT_CONFIG_CMD" project
}

ov_require_data_mount || exit 1

case ${1:-} in
  set)
    value=$(ov_normalize_application "${2:-}") || {
      echo "Unsupported application '${2:-}'." >&2
      exit 1
    }
    ov_write_state "$MAIN_APP_FILE" "$value" && project_boot_config
    ;;
  restore)
    if [ -e "$MAIN_APP_FILE" ]; then
      value=$(ov_read_application_file "$MAIN_APP_FILE") || {
        echo "Persistent application selection is invalid." >&2
        exit 1
      }
      project_boot_config
    elif value=$(read_boot_value); then
      ov_write_state "$MAIN_APP_FILE" "$value" && project_boot_config
    fi
    ;;
  *)
    echo "Usage: $0 {set APPLICATION|restore}" >&2
    exit 2
    ;;
esac
