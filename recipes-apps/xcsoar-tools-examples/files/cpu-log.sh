#!/bin/sh
# SPDX-License-Identifier: MIT

# Editable personal tool; systemd-run currently requires root.

UNIT=xcsoar-cpu-log.service
LOG_DIRECTORY=${XCSOAR_CPU_LOG_DIRECTORY:-"$(dirname "$0")/../logs"}
LOG_FILE=$LOG_DIRECTORY/xcsoar-cpu.csv
INTERVAL_SECONDS=${XCSOAR_CPU_LOG_INTERVAL:-10}

find_xcsoar_pid() {
	pid_list=$(/bin/pidof xcsoar 2>/dev/null) || return 1
	pid=${pid_list%% *}
	[ -n "$pid" ] || return 1
	printf '%s\n' "$pid"
}

read_process_ticks() {
	awk '{ printf "%.0f\n", $14 + $15 }' "/proc/$1/stat" 2>/dev/null
}

read_system_ticks() {
	awk '
		/^cpu / {
			total = 0
			for (i = 2; i <= NF; ++i)
				total += $i
			printf "%.0f\n", total
			exit
		}
	' /proc/stat
}

read_cpu_count() {
	awk '/^cpu[0-9]+ / { ++count } END { print count + 0 }' /proc/stat
}

run_logger() {
	stop_requested=false
	trap 'stop_requested=true' HUP INT TERM

	pid=$(find_xcsoar_pid) || {
		printf '%s\n' 'XCSoar is not running.' >&2
		exit 1
	}

	mkdir -p "$LOG_DIRECTORY" || exit 1
	touch "$LOG_FILE" || exit 1

	cpu_count=$(read_cpu_count)
	[ "$cpu_count" -gt 0 ] 2>/dev/null || cpu_count=1
	previous_process=$(read_process_ticks "$pid") || exit 1
	previous_system=$(read_system_ticks) || exit 1

	printf '# session started %s pid=%s interval=%ss\n' \
		"$(date '+%Y-%m-%dT%H:%M:%S%z')" "$pid" "$INTERVAL_SECONDS" \
		>> "$LOG_FILE"
	printf '%s\n' 'timestamp,pid,cpu_percent' >> "$LOG_FILE"

	while ! $stop_requested; do
		sleep "$INTERVAL_SECONDS" || break
		$stop_requested && break
		[ -r "/proc/$pid/stat" ] || break

		process_ticks=$(read_process_ticks "$pid") || break
		system_ticks=$(read_system_ticks) || break
		process_delta=$((process_ticks - previous_process))
		system_delta=$((system_ticks - previous_system))

		if [ "$system_delta" -gt 0 ]; then
			cpu_tenths=$((process_delta * 1000 * cpu_count / system_delta))
		else
			cpu_tenths=0
		fi

		printf '%s,%s,%s.%s\n' \
			"$(date '+%Y-%m-%dT%H:%M:%S%z')" \
			"$pid" "$((cpu_tenths / 10))" "$((cpu_tenths % 10))" \
			>> "$LOG_FILE"

		previous_process=$process_ticks
		previous_system=$system_ticks
	done

	printf '# session ended %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" \
		>> "$LOG_FILE"
}

if [ "${1:-}" = "--worker" ]; then
	run_logger
	exit $?
fi

if /bin/systemctl --quiet is-active "$UNIT"; then
	printf '%s\n' 'Stopping XCSoar CPU logging...'
	if ! /bin/systemctl stop "$UNIT"; then
		printf '%s\n' 'Could not stop XCSoar CPU logging.'
		exit 1
	fi

	printf '%s\n' "CPU logging stopped. Log: $LOG_FILE"
	exit 0
fi

if ! find_xcsoar_pid >/dev/null; then
	printf '%s\n' 'XCSoar is not running.'
	exit 1
fi

if ! mkdir -p "$LOG_DIRECTORY" || ! touch "$LOG_FILE"; then
	printf '%s\n' "Cannot write the CPU log: $LOG_FILE"
	exit 1
fi

printf '%s\n' 'Starting XCSoar CPU logging...'
if ! /usr/bin/systemd-run --quiet --collect --unit="$UNIT" \
	"$0" --worker; then
	printf '%s\n' 'Could not start XCSoar CPU logging.'
	exit 1
fi

printf '%s\n' "CPU logging started. Select this action again to stop it. Log: $LOG_FILE"
exit 0
