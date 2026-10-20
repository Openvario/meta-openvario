#!/bin/bash
# SPDX-License-Identifier: MIT
set -eu

repo=$(cd "$(dirname "$0")/../.." && pwd)
export OV_PATHS="$repo/recipes-apps/ov-data-storage/files/paths.sh"
workspace=$(mktemp -d /tmp/ov-boot-projection-test.XXXXXX)
cleanup() {
    touch "$workspace/release"
    for pid in ${projector_pid:-} ${selection_pid:-}; do
        wait "$pid" || true
    done
    rm -rf -- "$workspace"
}
trap cleanup EXIT

wait_for_file() {
    for ((attempt = 0; attempt < 500; ++attempt)); do
        [ ! -e "$1" ] || return 0
        sleep 0.01
    done
    return 1
}

settings="$repo/recipes-apps/ov-system-settings-sync/files"
export DATA_DIR="$workspace/data" OV_MOUNTPOINT=/bin/true
export SETTINGS_COMMON="$settings/settings-common.sh" BOOT_CONFIG_CMD="$settings/boot-config.sh"
export BOOT_CONFIG_FILE="$workspace/config.uEnv" BOOT_CONFIG_LOCK="$workspace/boot-config.lock"
export PROJECTION_WORKSPACE="$workspace"
app_state="$DATA_DIR/OpenVario/settings/application/main_app"
mkdir -p "$(dirname "$app_state")" "$workspace/bin"
printf 'xcsoar\n' > "$app_state"
printf 'brightness=10\n' > "$BOOT_CONFIG_FILE"

# Hold the older projection just before publication while the selection changes.
cat > "$workspace/bin/mv" <<'EOF'
#!/bin/sh
touch "$PROJECTION_WORKSPACE/ready"
while [ ! -e "$PROJECTION_WORKSPACE/release" ]; do sleep 0.01; done
exec /bin/mv "$@"
EOF
chmod 755 "$workspace/bin/mv"
PATH="$workspace/bin:$PATH" sh "$BOOT_CONFIG_CMD" project &
projector_pid=$!
wait_for_file "$workspace/ready"
if flock -n "$BOOT_CONFIG_LOCK" /bin/true; then exit 1; fi

(
    sh "$settings/main-app-config.sh" set OpenSoar
    touch "$workspace/selection-complete"
) &
selection_pid=$!
for ((attempt = 0; attempt < 500; ++attempt)); do
    [ "$(cat "$app_state")" != OpenSoar ] || break
    sleep 0.01
done
test "$(cat "$app_state")" = OpenSoar
test ! -e "$workspace/selection-complete"
touch "$workspace/release"
wait "$projector_pid"
wait "$selection_pid"
test -e "$workspace/selection-complete"
grep -q '^main_app=OpenSoar$' "$BOOT_CONFIG_FILE"
test "$(cat "$app_state")" = OpenSoar
printf '%s\n' 'Overlapping projection cannot revert a newly selected application.'
