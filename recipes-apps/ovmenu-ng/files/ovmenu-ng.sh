#!/bin/bash
# ovmenu-ng.sh - OpenVario application launcher dispatcher
#
# Loads config and prepares shared state, then starts the selected application.
# OpenSoar retains its compatibility menu.

APP_TTY_STATE=

INPUT=/tmp/menu.sh.$$

cd "$HOME"

trap "restore_app_tty; rm -f $INPUT; exit" SIGHUP SIGINT SIGTERM

# Load boot config for main_app selection
source /boot/config.uEnv

#==============================================================================
# Shared helpers (available to all sourced scripts)
#==============================================================================

function restore_app_tty() {
    if [ -n "$APP_TTY_STATE" ]; then
        stty "$APP_TTY_STATE" 2>/dev/null || true
        APP_TTY_STATE=
    fi
}

function error_stop() {
  echo "Error-Stop: $1"
  read -p "Press enter to continue"
}

function do_shell() {
    printf '\033[?25h'
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

function copy_xcsoar_defaults() {
    local defaults="$1" datadir="$2"
    local mapping extension subdir file basename

    rsync -a --ignore-existing --exclude='/*.prf' --exclude='/*.xcm' \
        --exclude='/*.xci' "$defaults/" "$datadir/" || return 1

    for mapping in prf:profiles xcm:maps xci:input; do
        extension=${mapping%%:*}
        subdir=${mapping#*:}
        for file in "$defaults/"*."$extension"; do
            [ -f "$file" ] || continue
            basename=${file##*/}
            # Let XCSoar migrate existing root files instead of blocking them.
            if [ -e "$datadir/$basename" ] || [ -L "$datadir/$basename" ]; then
                continue
            fi
            mkdir -p "$datadir/$subdir" && \
                rsync -a --ignore-existing "$file" "$datadir/$subdir/" || return 1
        done
    done
    return 0
}

# Seed partition 3 without replacing user files; retain defaults on failure.
function seed_xcsoar_data() {
    local datadir="$HOME/data/XCSoarData"
    if [ -d "$datadir" ] && [ -d "$HOME/.xcsoar" ]; then
        if copy_xcsoar_defaults "$HOME/.xcsoar" "$datadir" && sync; then
            rm -rf "$HOME/.xcsoar"
            sync
        else
            echo "XCSoar defaults could not be saved; retaining source for retry." >&2
        fi
    fi
}

function start_app_once() {
    case "$main_app" in
        "OpenSoar")
            /usr/bin/OpenSoar -fly -datapath=data/OpenSoarData
            ;;
        "xcsoar"|"XCSoar")
            # XCSoar reads input devices directly. Suppress the terminal's
            # independent echo so key presses cannot fill the console.
            APP_TTY_STATE=$(stty -g 2>/dev/null) || APP_TTY_STATE=
            if [ -n "$APP_TTY_STATE" ]; then
                stty -echo -echonl 2>/dev/null || true
            fi
            # Clear tty1 before graphics mode so Quit cannot reveal an old dialog.
            printf '\033[2J\033[H'
            /usr/bin/xcsoar -fly -touchscreen -datapath=data/XCSoarData
            ;;
        *)
            echo "Unknown main_app '$main_app'" >&2
            return 1
            ;;
    esac

    local rc=$?
    case "$main_app" in
        "xcsoar"|"XCSoar") restore_app_tty ;;
    esac
    /usr/bin/sync-display-config.sh 2>/dev/null || true
    return "$rc"
}

function start_app() {
    while true; do
        start_app_once
        local rc=$?

        # Restart only after consuming an exclusive XCSoar request.
        case "$main_app" in
            "xcsoar"|"XCSoar")
                if /usr/libexec/openvario/xcsoar-exclusive-handoff run \
                    "$XCSOAR_EXCLUSIVE_HANDOFF_DIR"; then
                    continue
                fi
                ;;
        esac
        return "$rc"
    done
}

# Update variod only when the user changes the selected application.
function configure_variod_for_app() {
    case "$1" in
        "OpenSoar")
            systemctl enable --now variod.service 2>/dev/null || true
            ;;
        "xcsoar"|"XCSoar")
            systemctl disable --now variod.service 2>/dev/null || true
            ;;
    esac
}

# App selector dialog - lets the user pick an app or drop to a shell.
# If a new app is selected, persist it and re-exec the dispatcher.
function select_app() {
    clear

    # On first boot, give a 60s countdown defaulting to XCSoar.
    # Users without a touchscreen cannot interact with the menu.
    if [ -z "$main_app" ]; then
        dialog --nook --nocancel --backtitle "OpenVario" \
                --pause "Starting XCSoar in 60 seconds...\n\nPress [ESC] to select a different application." \
        12 50 60 2>&1
        if [ $? -eq 0 ]; then
            # Timeout expired — default to XCSoar
            main_app="xcsoar"
            echo "main_app=$main_app" >> /boot/config.uEnv
            configure_variod_for_app "$main_app"
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
        configure_variod_for_app "$new_app"
    fi

    # Re-exec the dispatcher with the new selection
    exec /usr/bin/ovmenu-ng.sh
}

#==============================================================================
# Start the selected application
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
        seed_xcsoar_data
        start_app || echo "XCSoar exited unsuccessfully; returning to application selection." >&2
        sync
        # Ordinary Quit returns to application selection.
        while true; do
            select_app
        done
        ;;
    *)
        echo "Unknown main_app '$main_app' in /boot/config.uEnv" >&2
        select_app
        ;;
esac
