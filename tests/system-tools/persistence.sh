#!/bin/bash
# SPDX-License-Identifier: MIT
# Run with: bash tests/system-tools/persistence.sh (no root or device required).
set -eu

repo=$(cd "$(dirname "$0")/../.." && pwd)
export OV_PATHS="$repo/recipes-apps/ov-data-storage/files/paths.sh"
workspace=$(mktemp -d /tmp/ov-persistence-test.XXXXXX)
trap 'rm -rf -- "$workspace"' EXIT
persistence="$repo/recipes-apps/ov-persistence/files"
settings="$repo/recipes-apps/ov-system-settings-sync/files"
export DATA_DIR="$workspace/data"
export CONNMAN_LIVE_DIR="$workspace/connman" DROPBEAR_LIVE_DIR="$workspace/dropbear"
export SENSORD_CONFIG_FILE="$workspace/sensord.conf" VARIOD_CONFIG_FILE="$workspace/variod.conf"
export SENSORD_DEFAULT_FILE="$workspace/default-sensord" VARIOD_DEFAULT_FILE="$workspace/default-variod"
export POINTERCAL_LINK="$workspace/pointercal" LIBINPUT_RULE_LINK="$workspace/libinput-ts.rules"
export OV_MOUNTPOINT="$workspace/mountpoint" OV_MOUNT="$workspace/mount"
export OV_UDEVADM="$workspace/udevadm"
cat > "$OV_MOUNTPOINT" <<'EOF'
#!/bin/sh
[ "${FAIL_DATA_MOUNT:-0}" != 1 ] || exit 1
[ "$2" = "$DATA_DIR" ] || [ -e "$2.mounted" ]
EOF
cat > "$OV_MOUNT" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >> "$DATA_DIR/mounts"
[ "${FAIL_BIND:-0}" != 1 ] || exit 1
touch "$3.mounted"
EOF
cat > "$OV_UDEVADM" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >> "$DATA_DIR/udev"
[ "${FAIL_UDEV:-0}" != 1 ]
EOF
chmod 755 "$OV_MOUNTPOINT" "$OV_MOUNT" "$OV_UDEVADM"

for subsystem in connman dropbear sensord variod touchscreen; do
    if FAIL_DATA_MOUNT=1 sh "$persistence/persistence-$subsystem"; then exit 1; fi
done
test ! -e "$DATA_DIR/OpenVario"
mkdir -p "$DATA_DIR"
for subsystem in connman dropbear; do
    sh "$persistence/persistence-$subsystem"
    persistent="$DATA_DIR/OpenVario/system/$subsystem"
    test "$(stat -c %a "$persistent")" = 700
    printf 'retained secret\n' > "$persistent/settings"
    sh "$persistence/persistence-$subsystem"
    grep -q '^retained secret$' "$persistent/settings"
done
test "$(wc -l < "$DATA_DIR/mounts")" = 2
rm "$CONNMAN_LIVE_DIR.mounted"
if FAIL_BIND=1 sh "$persistence/persistence-connman"; then exit 1; fi

printf 'sensor default\n' > "$SENSORD_DEFAULT_FILE"
printf 'vario default\n' > "$VARIOD_DEFAULT_FILE"
for subsystem in sensord variod; do
    sh "$persistence/persistence-$subsystem"
    persistent="$DATA_DIR/OpenVario/system/$subsystem/$subsystem.conf"
    test "$(readlink "$workspace/$subsystem.conf")" = "$persistent"
    test "$(stat -c %a "$persistent")" = 600
    printf 'user configuration\n' > "$persistent"
    sh "$persistence/persistence-$subsystem"
    grep -q '^user configuration$' "$persistent"
done
if SENSORD_DEFAULT_FILE="$workspace/absent" SYSTEM_DIR="$workspace/fresh" \
    sh "$persistence/persistence-sensord"; then exit 1; fi

sh "$persistence/persistence-touchscreen"
test "$(readlink "$POINTERCAL_LINK")" = "$DATA_DIR/OpenVario/system/touchscreen/pointercal"
test "$(readlink "$LIBINPUT_RULE_LINK")" = "$DATA_DIR/OpenVario/system/touchscreen/libinput-ts.rules"
printf 'calibration rule\n' > "$LIBINPUT_RULE_LINK"
sh "$persistence/persistence-touchscreen"
grep -q '^trigger --subsystem-match=input --action=change$' "$DATA_DIR/udev"
grep -q '^settle$' "$DATA_DIR/udev"
if FAIL_UDEV=1 sh "$persistence/persistence-touchscreen"; then exit 1; fi
printf '%s\n' 'Native persistence: mount failures, retained state, seeding and touchscreen reload passed.'

export SETTINGS_COMMON="$settings/settings-common.sh"
export BOOT_CONFIG_CMD="$settings/boot-config.sh" BOOT_CONFIG_FILE="$workspace/config.uEnv"
export BOOT_CONFIG_LOCK="$workspace/boot-config.lock"
export BRIGHTNESS_SYSFS_FILE="$workspace/brightness" ROTATION_SYSFS_FILE="$workspace/rotation"
export ROTATION_ALL_SYSFS_FILE="$workspace/rotation" VTCONSOLE_PATH="$workspace/vtconsole"
export SYNC_DISPLAY_CONFIG="$settings/sync-display-config.sh"
display_state="$DATA_DIR/OpenVario/settings/display"
mkdir -p "$display_state" "$VTCONSOLE_PATH/vtcon1"
printf 'frame buffer device\n' > "$VTCONSOLE_PATH/vtcon1/name"
printf '0\n' > "$VTCONSOLE_PATH/vtcon1/bind"
printf 'rotation=3\nbrightness=10\nother=retained\n' > "$BOOT_CONFIG_FILE"
printf '3\n' > "$display_state/rotation"
printf '42\n' > "$BRIGHTNESS_SYSFS_FILE"
printf '0\n' > "$ROTATION_SYSFS_FILE"
sh "$SYNC_DISPLAY_CONFIG"
test "$(cat "$display_state/brightness")" = 42
test "$(stat -c %a "$display_state/brightness")" = 600
test "$(cat "$display_state/rotation")" = 3
grep -q '^rotation=3$' "$BOOT_CONFIG_FILE"
grep -q '^brightness=42$' "$BOOT_CONFIG_FILE"
grep -q '^other=retained$' "$BOOT_CONFIG_FILE"
inode=$(stat -c %i "$BOOT_CONFIG_FILE")
sh "$SYNC_DISPLAY_CONFIG"
test "$(stat -c %i "$BOOT_CONFIG_FILE")" = "$inode"
if BOOT_CONFIG_LOCK="$workspace/absent/lock" sh "$BOOT_CONFIG_CMD" project; then exit 1; fi
test "$(stat -c %i "$BOOT_CONFIG_FILE")" = "$inode"

printf '1\n' > "$VTCONSOLE_PATH/vtcon1/bind"
sh "$SYNC_DISPLAY_CONFIG"
test "$(cat "$display_state/rotation")" = 0
printf '3\n' > "$display_state/rotation"
# Model rotate_all accepting a write while the active console stays unchanged.
printf '1\n' > "$ROTATION_SYSFS_FILE"
touch "$workspace/rotate_all"
cp "$BOOT_CONFIG_FILE" "$workspace/before-restore.uEnv"
if ROTATION_ALL_SYSFS_FILE="$workspace/rotate_all" sh "$settings/restore-display-config.sh"; then exit 1; fi
test "$(cat "$display_state/rotation")" = 3
cmp "$BOOT_CONFIG_FILE" "$workspace/before-restore.uEnv"
sh "$settings/restore-display-config.sh"
test "$(cat "$ROTATION_SYSFS_FILE")" = 3
printf 'invalid\n' > "$display_state/rotation"
if sh "$settings/restore-display-config.sh"; then exit 1; fi
test "$(cat "$ROTATION_SYSFS_FILE")" = 3
printf '3\n' > "$display_state/rotation"
if FAIL_DATA_MOUNT=1 sh "$SYNC_DISPLAY_CONFIG"; then exit 1; fi
printf '%s\n' 'Display persistence: unbound fbcon, live capture, restore, validation and unchanged projection passed.'

sh "$settings/main-app-config.sh" set XCSoar
app_state="$DATA_DIR/OpenVario/settings/application/main_app"
test "$(cat "$app_state")" = xcsoar
if sh "$settings/main-app-config.sh" set unknown; then exit 1; fi
test "$(cat "$app_state")" = xcsoar
sed -i 's/^main_app=.*/main_app=OpenSoar/' "$BOOT_CONFIG_FILE"
sh "$settings/main-app-config.sh" restore
grep -q '^main_app=xcsoar$' "$BOOT_CONFIG_FILE"
rm "$app_state"
sed -i 's/^main_app=.*/main_app=OpenSoar/' "$BOOT_CONFIG_FILE"
sh "$settings/main-app-config.sh" restore
test "$(cat "$app_state")" = OpenSoar

export SYSTEMD_CONFIG="$workspace/systemd" OV_SYSTEMCTL="$workspace/systemctl"
cat > "$OV_SYSTEMCTL" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >> "$DATA_DIR/systemctl"
case "$*" in
    'show --property=LoadState --value '*) printf 'loaded\n' ;;
    '--quiet is-enabled dropbear.socket') exit 0 ;;
    '--quiet is-enabled '*) exit 1 ;;
esac
EOF
chmod 755 "$OV_SYSTEMCTL"
sh "$settings/service-policy.sh" capture
policy="$DATA_DIR/OpenVario/settings/services"
test "$(cat "$policy/dropbear.socket")" = enabled
test "$(cat "$policy/sensord.service")" = disabled
test "$(cat "$policy/variod.service")" = disabled
sh "$settings/service-policy.sh" restore
grep -q '^--no-block start dropbear.socket$' "$DATA_DIR/systemctl"
grep -q '^--no-block stop sensord.service$' "$DATA_DIR/systemctl"
printf 'invalid\n' > "$policy/dropbear.socket"
if sh "$settings/service-policy.sh" restore; then exit 1; fi
printf '%s\n' 'Application selection and service policy: capture, restore and invalid values passed.'

# A failed final command in prepare() must stop restore before touching services.
mkdir "$workspace/fail-permissions"
printf '#!/bin/sh\nexit 1\n' > "$workspace/fail-permissions/chmod"
chmod 755 "$workspace/fail-permissions/chmod"
before=$(wc -l < "$DATA_DIR/systemctl")
if PATH="$workspace/fail-permissions:$PATH" sh "$settings/service-policy.sh" restore; then exit 1; fi
test "$(wc -l < "$DATA_DIR/systemctl")" = "$before"

# Zero is a value; absent state preserves boot entries, and duplicates collapse.
(
    mkdir "$workspace/projection"
    export BOOT_CONFIG_FILE="$workspace/projection/config.uEnv"
    export BRIGHTNESS_FILE="$workspace/projection/brightness"
    export ROTATION_FILE="$workspace/projection/rotation"
    export MAIN_APP_FILE="$workspace/projection/main_app"
    printf 'brightness=1\nbrightness=2\nrotation=3\nrotation=2\nmain_app=xcsoar\nother=retained\n' > "$BOOT_CONFIG_FILE"
    printf '0\n' > "$BRIGHTNESS_FILE"
    printf '0\n' > "$ROTATION_FILE"
    sh "$BOOT_CONFIG_CMD" project
    printf 'brightness=0\nrotation=0\nmain_app=xcsoar\nother=retained\n' > "$workspace/expected.uEnv"
    cmp "$BOOT_CONFIG_FILE" "$workspace/expected.uEnv"
    inode=$(stat -c %i "$BOOT_CONFIG_FILE")
    sh "$BOOT_CONFIG_CMD" project
    test "$(stat -c %i "$BOOT_CONFIG_FILE")" = "$inode"
    printf 'OpenSoar\n' > "$MAIN_APP_FILE"
    sh "$BOOT_CONFIG_CMD" project
    grep -q '^main_app=OpenSoar$' "$BOOT_CONFIG_FILE"
    cp "$BOOT_CONFIG_FILE" "$workspace/expected.uEnv"
    printf '4\n' > "$ROTATION_FILE"
    if sh "$BOOT_CONFIG_CMD" project; then exit 1; fi
    cmp "$BOOT_CONFIG_FILE" "$workspace/expected.uEnv"
)
printf '%s\n' 'Boot projection: zero, absent state, duplicates and invalid values passed.'
