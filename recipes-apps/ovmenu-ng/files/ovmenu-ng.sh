#!/bin/bash
# ovmenu-ng.sh - OpenVario application launcher dispatcher
#
# Thin entry point that loads config, sets up shared state, then
# sources the appropriate app-specific menu script.

DEBUG_STOP=No

INPUT=/tmp/menu.sh.$$

cd "$HOME"

trap "rm -f $INPUT /tmp/tail.$$; exit" SIGHUP SIGINT SIGTERM

# Load boot config for main_app selection
source /boot/config.uEnv

#==============================================================================
# Shared helpers (available to all sourced scripts)
#==============================================================================

function error_stop() {
  echo "Error-Stop: $1"
  read -p "Press enter to continue"
}

function debug_stop() {
    if [ "$DEBUG_STOP" = "Yes" ]; then
      echo "Debug-Stop: $1"
      read -p "Press enter to continue"
    fi
}

function do_shell() {
    clear
    cd

    # Redirect stderr to stdout because stderr is connected to
    # systemd-journald, which breaks interactive shells.
    if test -x /bin/bash; then
        /bin/bash --login 2>&1
    elif test -x /bin/ash; then
        /bin/ash -i 2>&1
    else
        /bin/sh 2>&1
    fi
}

function start_app() {
    case "$main_app" in
        "OpenSoar")
            /usr/bin/OpenSoar -fly -datapath=data/OpenSoarData
            ;;
        "xcsoar"|"XCSoar")
            /usr/bin/xcsoar -fly -touchscreen -datapath=data/XCSoarData
            ;;
        *)
            echo "Unknown main_app '$main_app'" >&2
            return 1
            ;;
    esac
    return $?
}

# App selector dialog - lets the user pick an app or drop to a shell.
# If a new app is selected, persist it and re-exec the dispatcher.
function select_app() {
    clear

    # On first boot, give a 60s countdown defaulting to OpenSoar.
    # Users without a touchscreen cannot interact with the menu.
    if [ -z "$main_app" ]; then
        dialog --nook --nocancel --backtitle "OpenVario" \
                --pause "Starting OpenSoar in 60 seconds...\n\nPress [ESC] to select a different application." \
        12 50 60 2>&1
        if [ $? -eq 0 ]; then
            # Timeout expired — default to OpenSoar
            main_app="OpenSoar"
            echo "main_app=$main_app" >> /boot/config.uEnv
            exec /usr/bin/ovmenu-ng.sh
        fi
    fi

    dialog --nocancel --backtitle "OpenVario" \
            --title "[ Application ]" \
            --begin 3 4 \
            --menu "Select application:" 12 50 3 \
            OpenSoar  "Start OpenSoar" \
            XCSoar    "Start XCSoar" \
            Terminal  "Go to terminal" 2>"${INPUT}"

    local choice=$(<"${INPUT}")

    case "$choice" in
        Terminal) do_shell; return ;;
        OpenSoar) local new_app="OpenSoar" ;;
        XCSoar)   local new_app="xcsoar" ;;
        *)        do_shell; return ;;
    esac

    if [ "$new_app" != "$main_app" ]; then
        if grep -q '^main_app=' /boot/config.uEnv 2>/dev/null; then
            sed -i "s/^main_app=.*/main_app=$new_app/" /boot/config.uEnv
        else
            echo "main_app=$new_app" >> /boot/config.uEnv
        fi
    fi

    # Re-exec the dispatcher with the new selection
    exec /usr/bin/ovmenu-ng.sh
}

#==============================================================================
# Dispatch to app-specific script
#==============================================================================

# First-boot selector: if main_app is not set, force a choice
if [ -z "$main_app" ]; then
    select_app
fi

case "$main_app" in
    "OpenSoar")
        source /usr/bin/ovmenu-ng-opensoar.sh
        ;;
    "xcsoar"|"XCSoar")
        source /usr/bin/ovmenu-ng-xcsoar.sh
        ;;
    *)
        echo "Unknown main_app '$main_app' in /boot/config.uEnv" >&2
        select_app
        ;;
esac
