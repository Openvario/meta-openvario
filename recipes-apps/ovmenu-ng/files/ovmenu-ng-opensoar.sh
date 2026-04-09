#!/bin/bash

DEBUG_STOP=No

INPUT=/tmp/menu.sh.$$
DATADIR=$HOME/data

# trap and delete temp files
trap "rm $INPUT;rm /tmp/tail.$$; exit" SIGHUP SIGINT SIGTERM
#------------------------------------------------------------------------------
function error_stop() {
  echo "Error-Stop: $1"
  read -p "Press enter to continue"
}
#------------------------------------------------------------------------------
function debug_stop() {
    if [ "$DEBUG_STOP" = "Yes" ]; then
      echo "Debug-Stop: $1"
      read -p "Press enter to continue"
    fi
}

#=========================================================================
# this second resolve the 'blind shell' issue?
sleep 1
#=========================================================================
source /boot/config.uEnv

cd $HOME

#------------------------------------------------------------------------------
function do_shell() {
    clear
    cd

    # Redirecting stderr to stdout (= the console)
    # because stderr is currently connected to
    # systemd-journald, which breaks interactive
    # shells.
    if test -x /bin/bash; then
        /bin/bash --login 2>&1
    elif test -x /bin/ash; then
        /bin/ash -i 2>&1
    else
        /bin/sh 2>&1
    fi
    
}

#------------------------------------------------------------------------------
function start_mainapp() {
  debug_stop "main_app = $main_app"
  case "$main_app" in
    "OpenSoar") 
          debug_stop "/usr/bin/OpenSoar -fly -datapath=data/OpenSoarData"
          /usr/bin/OpenSoar -fly -datapath=data/OpenSoarData
          ;;
    "xcsoar"|"XCSoar") 
          debug_stop "/usr/bin/xcsoar -fly -datapath=data/XCSoarData"
          /usr/bin/xcsoar -fly  -datapath=data/XCSoarData
          ;;
    *) ;;
  esac
}
#==============================================================================
#==============================================================================
#==============================================================================

clear
sync

### /usr/bin/OpenVarioBaseMenu 0
start_mainapp
exit_value=$?
while true
do
   wait
   debug_stop "End OpenSoar with $exit_value" 
   case $exit_value in
     134 | 138 | 139 | 1)
        # Crash in OpenSoar...
        echo "\n"
        error_stop "Crash (1) in OpenSoar with Exit value: $exit_value" 
        do_shell
       ;;
     200)
         # happen with Quit Command from QuickMenu: 
         # error_stop "Stopped before clear in shell ($exit_value)!" 
         do_shell;;
     201) /sbin/reboot;;
     202) /sbin/poweroff;;
     203) do_shell;;
     204) 
        echo "\n"
        echo "Finish OpenSoar with $exit_value"
        error_stop "Stopped before clear in shell!" 
        do_shell ;;
     205) /usr/bin/fw-upgrade.sh ;;
     206) /usr/bin/ov-calibrate-ts.sh ;;
     207)
          ## /usr/bin/OpenVarioBaseMenu
          do_shell ;;
     208 | 209)
          ## RESTART, NEWSTART w/o stop!
          ;;
     100 | 0 | 1) 
        do_shell ;;
     *)
        echo "\n"
        # Crash in OpenSoar...
        ## error_stop "OpenSoar finished with unknown '$exit_value'"
        echo "OpenSoar finished with unknown Exit value: '$exit_value'\n"
        read -s -n1  key
        case $key in
        
          $'\e')
                 # with ESC got shell
                 do_shell ;;
          $'\n')
                 # restart only if ENTER!
                 ;; 
          *) do_shell ;; 
        esac
   esac
   ### /usr/bin/OpenVarioBaseMenu
   start_mainapp
   exit_value=$?
done

