#!/bin/bash
# SPDX-License-Identifier: MIT
set -eu

repo=$(cd "$(dirname "$0")/../.." && pwd)
workspace=$(mktemp -d /tmp/ov-legacy-restore-test.XXXXXX)
trap 'rm -rf -- "$workspace"' EXIT
mkdir "$workspace/bin"
export RESTORE_COMMANDS="$workspace/commands"
cat > "$workspace/bin/mock-command" <<'EOF'
#!/bin/sh
printf '%s\n' "$0 $*" >> "$RESTORE_COMMANDS"
case ${0##*/} in
    rsync) cat >> "$RESTORE_COMMANDS.files" ;;
esac
EOF
chmod 755 "$workspace/bin/mock-command"
for command in ip sync rsync systemctl rm lsattr; do
    ln -s mock-command "$workspace/bin/$command"
done

# Keep a regression against the old restore body confined to the fixture.
sed -e "s|/bin/systemctl|$workspace/bin/systemctl|g" \
    -e "s|/home/root|$workspace/root|g" \
    -e "s|/sys/|$workspace/sys/|g" \
    -e "s|/boot/|$workspace/boot/|g" \
    -e "s|/usb/|$workspace/usb/|g" \
    "$repo/recipes-apps/ovmenu-ng-skripts/files/transfer-system.sh" \
    > "$workspace/transfer-system.sh"
if PATH="$workspace/bin:$PATH" sh "$workspace/transfer-system.sh" restore OpenSoar \
    > "$workspace/output" 2>&1; then exit 1; fi
grep -q 'Legacy system restore is unavailable' "$workspace/output"
grep -q 'No files were changed' "$workspace/output"
test ! -e "$RESTORE_COMMANDS"
printf '%s\n' 'Legacy system restore is rejected before running any transfer commands.'

mkdir -p "$workspace/root/.xcsoar" "$workspace/sys/class/backlight/lcd"
printf 'profile\n' > "$workspace/root/.xcsoar/test.prf"
printf '8\n' > "$workspace/sys/class/backlight/lcd/brightness"
PATH="$workspace/bin:$PATH" sh "$workspace/transfer-system.sh" backup OpenSoar \
    > "$workspace/output" 2>&1
test "$(grep -c '/rsync ' "$RESTORE_COMMANDS")" = 1
grep -Fx "$workspace/root" "$RESTORE_COMMANDS.files" >/dev/null
grep -q '^unprotected$' "$workspace/root/profile-settings/test"
printf '%s\n' 'Legacy backup makes one USB transfer including the persistent data parent.'
