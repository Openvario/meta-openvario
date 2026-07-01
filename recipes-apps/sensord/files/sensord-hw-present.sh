#!/bin/sh

# Skip sensord cleanly when the OpenVario sensorboard EEPROM on i2c-1 does
# not answer. This avoids starting a daemon that can only spin on systems
# without a connected sensorboard.

if [ ! -c /dev/i2c-1 ]; then
	echo "sensord: /dev/i2c-1 not available, skipping start" >&2
	exit 1
fi

if ! command -v i2cget >/dev/null 2>&1; then
	echo "sensord: i2cget not available, skipping start" >&2
	exit 1
fi

if i2cget -y 1 0x50 0x00 >/dev/null 2>&1; then
	exit 0
fi

echo "sensord: no sensorboard EEPROM on i2c-1, skipping start" >&2
exit 1
