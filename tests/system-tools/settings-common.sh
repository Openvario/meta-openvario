#!/bin/bash
# SPDX-License-Identifier: MIT
set -eu
repo=$(cd "$(dirname "$0")/../.." && pwd)
export OV_PATHS="$repo/recipes-apps/ov-data-storage/files/paths.sh"
env -i PATH="$PATH" sh -eu -c '
    . "$1"
    test "$DATA_DIR" = /home/root/data
    test "$SYSTEM_DIR" = /home/root/data/OpenVario/system
    test "$SETTINGS_DIR" = /home/root/data/OpenVario/settings
    test "$CONNMAN_DIR" = /home/root/data/OpenVario/system/connman
    test "$POINTERCAL_FILE" = /home/root/data/OpenVario/system/touchscreen/pointercal
    test "$BOOT_CONFIG_FILE" = /boot/config.uEnv
' sh "$OV_PATHS"
env -i PATH="$PATH" DATA_DIR=/tmp/ov-test-data SERVICE_POLICY_DIR=/tmp/ov-test-policy TOUCHSCREEN_DIR=/tmp/ov-test-touchscreen sh -eu -c '
    . "$1"
    test "$DATA_DIR" = /tmp/ov-test-data
    test "$SYSTEM_DIR" = /tmp/ov-test-data/OpenVario/system
    test "$SERVICE_POLICY_DIR" = /tmp/ov-test-policy
    test "$TOUCHSCREEN_DIR" = /tmp/ov-test-touchscreen
    test "$POINTERCAL_FILE" = /tmp/ov-test-touchscreen/pointercal
    test "$LIBINPUT_RULE_FILE" = /tmp/ov-test-touchscreen/libinput-ts.rules
' sh "$OV_PATHS"
. "$repo/recipes-apps/ov-system-settings-sync/files/settings-common.sh"
workspace=$(mktemp -d /tmp/ov-settings-reader.XXXXXX)
trap 'rm -rf -- "$workspace"' EXIT
for number in 0 3 10; do
    printf ' %s \n' "$number" > "$workspace/value"
    test "$(ov_read_unsigned_file "$workspace/value")" = "$number"
done
for value in '' -1 invalid; do
    printf '%s\n' "$value" > "$workspace/value"
    if ov_read_unsigned_file "$workspace/value"; then exit 1; fi
done
if ov_read_unsigned_file "$workspace/absent"; then exit 1; fi
printf '%s\n' 'Shared settings reader: zero, whitespace, invalid and missing values passed.'
