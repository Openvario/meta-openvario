#!/bin/bash
# SPDX-License-Identifier: MIT
# Run with: bash tests/system-tools/seeding.sh
set -eu

repo=$(cd "$(dirname "$0")/../.." && pwd)
workspace=$(mktemp -d /tmp/ov-seeding-test.XXXXXX)
trap 'rm -rf -- "$workspace"' EXIT
source <(sed -n '/^function copy_xcsoar_defaults()/,/^# Seed partition/p' \
	"$repo/recipes-apps/ovmenu-ng/files/ovmenu-ng.sh")

mkdir -p "$workspace/defaults/tools" "$workspace/data/profiles" "$workspace/data/tools"
printf 'packaged profile\n' > "$workspace/defaults/openvario.prf"
printf 'packaged map\n' > "$workspace/defaults/map.xcm"
printf 'packaged input\n' > "$workspace/defaults/openvario.xci"
printf 'packaged tool\n' > "$workspace/defaults/tools/cpu-log.sh"
printf 'hidden default\n' > "$workspace/defaults/.hidden"
printf 'user tool\n' > "$workspace/data/tools/cpu-log.sh"

copy_xcsoar_defaults "$workspace/defaults" "$workspace/data"
test -f "$workspace/data/profiles/openvario.prf"
test -f "$workspace/data/maps/map.xcm"
test -f "$workspace/data/input/openvario.xci"
test -f "$workspace/data/.hidden"
test ! -e "$workspace/data/openvario.prf"
grep -q '^user tool$' "$workspace/data/tools/cpu-log.sh"

printf 'user profile\n' > "$workspace/data/profiles/openvario.prf"
printf 'legacy profile\n' > "$workspace/data/legacy.prf"
printf 'packaged legacy profile\n' > "$workspace/defaults/legacy.prf"
copy_xcsoar_defaults "$workspace/defaults" "$workspace/data"
grep -q '^user profile$' "$workspace/data/profiles/openvario.prf"
test ! -e "$workspace/data/profiles/legacy.prf"
printf '%s\n' 'Typed seeding preserves user tools, typed profiles and legacy files.'
