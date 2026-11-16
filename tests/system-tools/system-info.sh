#!/bin/bash
# SPDX-License-Identifier: MIT
# Run with: bash tests/system-tools/system-info.sh
set -eu

repo=$(cd "$(dirname "$0")/../.." && pwd)
workspace=$(mktemp -d /tmp/ov-system-info-test.XXXXXX)
trap 'rm -rf -- "$workspace"' EXIT
mkdir "$workspace/bin"
for utility in awk cat sed tr uname; do
	ln -s "$(command -v "$utility")" "$workspace/bin/$utility"
done
for utility in opkg ip systemctl; do
	ln -s /bin/true "$workspace/bin/$utility"
done

if PATH="$workspace/bin" command -v hostname >/dev/null; then exit 1; fi
PATH="$workspace/bin" /bin/sh "$repo/recipes-apps/ov-system-tools/files/system-info" \
	> "$workspace/output" 2> "$workspace/errors"
IFS= read -r expected < /proc/sys/kernel/hostname
grep -Fx "Hostname: $expected" "$workspace/output" >/dev/null
test ! -s "$workspace/errors"
printf '%s\n' 'System information works without a hostname executable.'
