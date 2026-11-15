#!/bin/bash
# ov-system-init.sh - Startup preparation after psplash and before menu
#
# Sets display brightness and restores configuration after firmware upgrade.
# Storage is prepared first by ov-data-storage.service.
#
# All operations are idempotent - safe to run if the system is already
# initialized.
# Keep this script free of extra file logging because it runs during the
# psplash-to-menu handover on Cubieboard2.

HOME=/home/root
# shellcheck source=/dev/null
. "${OV_PATHS:-/usr/libexec/openvario/paths.sh}" || exit 1
DEBUG_LOG=$HOME/start-debug.log
RECOVER_DIR=$HOME/recover_data

# --- Load boot configuration ---
if [ -f "$BOOT_CONFIG_FILE" ]; then
  # shellcheck source=/dev/null
  source "$BOOT_CONFIG_FILE"
fi

# --- Set display brightness ---
if [ -w /sys/class/backlight/lcd/brightness ]; then
  echo "${brightness:-10}" > /sys/class/backlight/lcd/brightness
fi

cd "$HOME"

# --- Post-upgrade config restore ---
if [ -f "$RECOVER_DIR/upgrade.cfg" ]; then
  /usr/bin/psplash-message "Restoring configuration..." 2>/dev/null || true
  echo "Update system config"
  export HOME DEBUG_LOG
  DATADIR="$DATA_DIR" /usr/bin/update-system-config.sh
elif [ ! -f "$RECOVER_DIR/_upgrade.cfg" ]; then
  echo "upgrade.cfg not found"
else
  echo "only backup config found"
fi

# Prepare application data directories after storage recovery.
mkdir -p "$DATA_DIR/OpenSoarData" "$DATA_DIR/XCSoarData" ||
  {
    /usr/bin/psplash-message "Data storage setup failed" 2>/dev/null || true
    echo "Cannot initialize application data directories" >&2
    exit 1
  }

exit 0
