#!/bin/bash
# SPDX-License-Identifier: MIT
# Run with: bash tests/system-tools/run.sh (no root or device required).
set -eu

repo=$(cd "$(dirname "$0")/../.." && pwd)
bash "$repo/tests/system-tools/system-info.sh"
bash "$repo/tests/system-tools/seeding.sh"
workspace=$(mktemp -d /tmp/ov-system-tools-test.XXXXXX)
trap 'rm -rf -- "$workspace"' EXIT
mkdir "$workspace/bin"
cp "$repo/tests/system-tools/mock-command" "$workspace/bin/mock-command"
chmod 755 "$workspace/bin/mock-command"
for name in systemctl udevadm ts_calibrate cp pidof systemd-cat mktemp mv; do
	ln -s mock-command "$workspace/bin/$name"
done
export PATH="$workspace/bin:$PATH"
export OV_SYSTEMCTL="$workspace/bin/systemctl"
export OV_UDEVADM="$workspace/bin/udevadm"
export OV_TS_CALIBRATE="$workspace/bin/ts_calibrate"
export OV_PIDOF="$workspace/bin/pidof"
export OV_SYSTEMD_CAT="$workspace/bin/systemd-cat"
export OV_TERMINATE_GRACE_SECONDS=1

new_case() {
	export CASE_DIRECTORY
	CASE_DIRECTORY=$(mktemp -d "$workspace/case.XXXXXX")
	export OV_RUNTIME_DIRECTORY="$CASE_DIRECTORY"
	export OV_TOUCH_DEVICE="$CASE_DIRECTORY/touch"
	export OV_ROTATE_PATH="$CASE_DIRECTORY/rotation"
	export OV_POINTERCAL_PATH="$CASE_DIRECTORY/pointercal"
	export OV_LIBINPUT_RULE_PATH="$CASE_DIRECTORY/rule"
	printf '3\n' > "$OV_ROTATE_PATH"
	printf 'original calibration\n' > "$OV_POINTERCAL_PATH"
	printf 'original rule\n' > "$OV_LIBINPUT_RULE_PATH"
	printf 'active\n' > "$CASE_DIRECTORY/service"
	touch "$OV_TOUCH_DEVICE"
}

calibrate() {
	sh "$repo/recipes-apps/ov-system-tools/files/touchscreen-calibration" \
		> "$CASE_DIRECTORY/output" 2>&1
}

new_case
calibrate
grep -q '^new calibration$' "$OV_POINTERCAL_PATH"
grep -q '^active$' "$CASE_DIRECTORY/service"
test -z "$(find "$CASE_DIRECTORY" -name '*.backup' -print)"

new_case
if FAIL_APPLY=1 calibrate; then exit 1; fi
grep -q '^original calibration$' "$OV_POINTERCAL_PATH"
grep -q '^original rule$' "$OV_LIBINPUT_RULE_PATH"
grep -q '^active$' "$CASE_DIRECTORY/service"

new_case
if FAIL_APPLY=1 FAIL_ROLLBACK=1 calibrate; then exit 1; fi
backup=$(find "$CASE_DIRECTORY" -name pointercal.backup -print)
test -n "$backup"
grep -q '^original calibration$' "$backup"
grep -q 'Recovery files:.*lost on reboot' "$CASE_DIRECTORY/output"
grep -q '^active$' "$CASE_DIRECTORY/service"

new_case
if CALIBRATION_BLOCKS=1 OV_CALIBRATION_TIMEOUT_SECONDS=1 calibrate; then exit 1; fi
grep -q 'timed out' "$CASE_DIRECTORY/output"
grep -q '^original calibration$' "$OV_POINTERCAL_PATH"
grep -q '^active$' "$CASE_DIRECTORY/service"
! kill -0 "$(cat "$CASE_DIRECTORY/child-pid")" 2>/dev/null

new_case
CALIBRATION_BLOCKS=1 sh "$repo/recipes-apps/ov-system-tools/files/touchscreen-calibration" \
	> "$CASE_DIRECTORY/output" 2>&1 &
worker=$!
for ((attempt = 0; attempt < 200; ++attempt)); do
	[ ! -e "$CASE_DIRECTORY/child-pid" ] || break
	sleep 0.01
done
test -e "$CASE_DIRECTORY/child-pid"
kill -TERM "$worker"
if wait "$worker"; then exit 1; fi
grep -q 'cancelled' "$CASE_DIRECTORY/output"
grep -q '^original calibration$' "$OV_POINTERCAL_PATH"
grep -q '^active$' "$CASE_DIRECTORY/service"
! kill -0 "$(cat "$CASE_DIRECTORY/child-pid")" 2>/dev/null

printf '%s\n' 'Touchscreen apply, rollback, recovery, timeout and cancellation passed.'

handoff_script="$repo/recipes-apps/ovmenu-ng/files/xcsoar-exclusive-handoff"
new_handoff() {
	new_case
	handoff="$CASE_DIRECTORY/handoff"
	mkdir -m 700 "$handoff"
	export OV_XCSOAR_SYSTEM_TOOL_DIR="$CASE_DIRECTORY/tools"
	mkdir "$OV_XCSOAR_SYSTEM_TOOL_DIR"
	cp "$workspace/bin/mock-command" "$OV_XCSOAR_SYSTEM_TOOL_DIR/touchscreen-calibration"
	sh "$handoff_script" prepare "$handoff"
	printf 'touchscreen-calibration\n' > "$handoff/request"
}

run_handoff() {
	sh "$handoff_script" run "$handoff" > "$CASE_DIRECTORY/handoff-log" 2>&1
}

for status in 0 1; do
	new_handoff
	TOOL_STATUS=$status run_handoff
	if [ "$status" = 0 ]; then result=success; else result=failure; fi
	test "$(sed -n '2p' "$handoff/result")" = "$result"
	test "$(stat -c %a "$handoff/result")" = 600
	test ! -e "$handoff/request"
	test ! -e "$handoff/request.in-progress"
	if run_handoff; then exit 1; fi
	test "$(wc -l < "$CASE_DIRECTORY/invocations")" = 1
done

for failure in create rename; do
	new_handoff
	FAIL_PUBLISH=$failure run_handoff
	test ! -e "$handoff/result"
	test ! -e "$handoff/request"
	output=$(find "$handoff" -name '.output.*' -print)
	test -n "$output"
	grep -q 'Calibration test output' "$output"
	grep -q 'Could not publish exclusive tool result' "$CASE_DIRECTORY/handoff-log"
	grep -q 'Calibration test output' "$CASE_DIRECTORY/handoff-log"
	if run_handoff; then exit 1; fi
	test "$(wc -l < "$CASE_DIRECTORY/invocations")" = 1
done

new_handoff
FAIL_PUBLISH=output run_handoff
test ! -e "$CASE_DIRECTORY/invocations"
grep -q 'action was not run' "$CASE_DIRECTORY/handoff-log"

new_handoff
printf 'unknown-tool\n' > "$handoff/request"
run_handoff
test "$(sed -n '2p' "$handoff/result")" = failure
test ! -e "$CASE_DIRECTORY/invocations"

new_handoff
printf 'touchscreen-calibration\nextra\n' > "$handoff/request"
run_handoff
grep -q '^invalid-request$' "$handoff/result"
test ! -e "$CASE_DIRECTORY/invocations"

new_handoff
TOOL_LARGE_OUTPUT=1 run_handoff
test "$(wc -c < "$handoff/result")" -le 8192
grep -q 'too much output' "$handoff/result"

new_handoff
touch "$handoff/request.in-progress"
run_handoff
test ! -e "$CASE_DIRECTORY/invocations"
printf 'touchscreen-calibration\n' > "$handoff/request"
sh "$handoff_script" prepare "$handoff"
test ! -e "$handoff/request"

new_handoff
TOOL_BLOCKS=1 sh "$handoff_script" run "$handoff" \
	> "$CASE_DIRECTORY/handoff-log" 2>&1 &
worker=$!
for ((attempt = 0; attempt < 200; ++attempt)); do
	[ ! -e "$CASE_DIRECTORY/child-pid" ] || break
	sleep 0.01
done
test -e "$CASE_DIRECTORY/child-pid"
kill -TERM "$worker"
if wait "$worker"; then exit 1; fi
test "$(sed -n '2p' "$handoff/result")" = failure
grep -q 'cancelled' "$handoff/result"
! kill -0 "$(cat "$CASE_DIRECTORY/child-pid")" 2>/dev/null
printf '%s\n' 'Handoff status, publication failures, bounds, no replay and cancellation passed.'
