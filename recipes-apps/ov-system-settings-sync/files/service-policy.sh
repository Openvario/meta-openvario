#!/bin/sh
# SPDX-License-Identifier: MIT

SETTINGS_COMMON=${SETTINGS_COMMON:-/usr/libexec/openvario/settings-common.sh}

# shellcheck source=/dev/null
. "$SETTINGS_COMMON" || exit 1

SYSTEMD_CONFIG=${SYSTEMD_CONFIG:-/etc/systemd/system}
SYSTEMCTL_CMD=${OV_SYSTEMCTL:-/bin/systemctl}
UNITS='dropbear.socket sensord.service variod.service'

unit_exists() {
  load_state=$($SYSTEMCTL_CMD show --property=LoadState --value "$1" 2>/dev/null) ||
    return 1
  [ "$load_state" != not-found ]
}

prepare() {
  mkdir -p "$SERVICE_POLICY_DIR" \
    "$SYSTEMD_CONFIG/sockets.target.wants" \
    "$SYSTEMD_CONFIG/multi-user.target.wants" || return 1
  chmod 0700 "$SETTINGS_DIR" "$SERVICE_POLICY_DIR"
}

ov_require_data_mount || exit 1

prepare || exit 1

case ${1:-} in
  capture)
    for unit in $UNITS; do
      unit_exists "$unit" || continue
      if $SYSTEMCTL_CMD --quiet is-enabled "$unit" 2>/dev/null; then
        ov_write_state "$SERVICE_POLICY_DIR/$unit" enabled || exit 1
      else
        ov_write_state "$SERVICE_POLICY_DIR/$unit" disabled || exit 1
      fi
    done
    ;;
  restore)
    for unit in $UNITS; do
      state_file=$SERVICE_POLICY_DIR/$unit
      [ -r "$state_file" ] || continue
      unit_exists "$unit" || continue
      state=$(ov_read_trimmed_file "$state_file") || exit 1
      case $state in
        enabled)
          $SYSTEMCTL_CMD enable "$unit" >/dev/null || exit 1
          $SYSTEMCTL_CMD --no-block start "$unit" >/dev/null || exit 1
          ;;
        disabled)
          $SYSTEMCTL_CMD disable "$unit" >/dev/null || exit 1
          $SYSTEMCTL_CMD --no-block stop "$unit" >/dev/null || exit 1
          ;;
        *)
          echo "Invalid persistent policy for $unit." >&2
          exit 1
          ;;
      esac
    done
    ;;
  *)
    echo "Usage: $0 {capture|restore}" >&2
    exit 2
    ;;
esac
