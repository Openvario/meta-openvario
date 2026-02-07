#!/bin/bash

DEBUG_STOP=No

INPUT=/tmp/menu.sh.$$
DATADIR=$HOME/data
USB_STICK=/usb/usbstick
USB_OPENVARIO=$USB_STICK/openvario
RECOVER_DIR=$HOME/recover_data
DEBUG_LOG=$HOME/start-debug.log

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
source /home/config.uEnv
# a hidden possibility to change this file with a file from the USB-DIR
if [ -z "$1" ]; then
  if [ "$0" = "/usr/bin/ovmenu-ng.sh" ]; then
    echo "Call another ovmenu-ng.sh to change it 'on the fly'"
    if [ -f "$USB_OPENVARIO/ovmenu-ng.sh" ]; then 
      cp -vf "$USB_OPENVARIO/ovmenu-ng.sh" $HOME/
      chmod 757 $HOME/ovmenu-ng.sh
      echo "call '$HOME/ovmenu-ng.sh'"
      $HOME/ovmenu-ng.sh "New Start"
      echo "Extra ovmenu from '$USB_OPENVARIO'"
      exit
      debug_stop " exit after '$HOME/ovmenu-ng.sh'"
    fi
  fi
fi

#=========================================================================
#=========================================================================
#=========================================================================
echo "begin startup.."
echo "===============" 
chmod -Rf 757 $HOME
mv $HOME/start-debug-1.log $HOME/start-debug-2.log
mv $DEBUG_LOG $HOME/start-debug-1.log
source /boot/config.uEnv
if [[ -z "$brightness" ]]; then 
  brightness=10
fi
echo "$brightness" >/sys/class/backlight/lcd/brightness
debug_stop "set brightness to '$brightness'"

#------------------------------------------------------------------------------
# set system configs if upgrade.cfg is available (from Upgrade)
cd $HOME
if [ -f $RECOVER_DIR/upgrade.cfg ]; then
  echo "Update system config" > sysconfig.txt
  /usr/bin/update-system-config.sh
elif [ ! -f $RECOVER_DIR/_upgrade.cfg ]; then
  echo "upgrade.cfg not found" > sysconfig.txt
else
  echo "only backup config found !!!!!" > sysconfig.txt
fi

#------------------------------------------------------------------------------
echo "begin startup.. $(date %Y-%m-%d %H:%M:%S)" >> $DEBUG_LOG
DATESTRING=$(date %Y-%m-%d %H:%M:%S)
date %Y-%m-%d %H:%M:%S >> $DEBUG_LOG
echo "=================================" >> $DEBUG_LOG
if [ ! -e /dev/mmcblk0p3 ]; then
  echo "/dev/mmcblk0p3 don't exist " >> $DEBUG_LOG
  ls -l /dev/mm* >> $DEBUG_LOG
  # create the 3rd SD card partition:
  source /usr/bin/create_datapart.sh

  echo "Debug: 3rd SD card partition created" >> $DEBUG_LOG
  if [ -f $HOME/_upgrade.cfg ]; then
    # reactivate the previous system data
    mv -f $HOME/_upgrade.cfg $HOME/upgrade.cfg
  fi 
      ### read -p "Press enter to continue"
  if [ ! -e /dev/mmcblk0p3 ]; then
    echo "Reboot ====================================" >> $DEBUG_LOG
    echo "Wait until OpenVario after Reboot is ready!" >> $DEBUG_LOG
    reboot
    ### read -p "Press enter to continue"
  fi
fi

#------------------------------------------------------------------------------
# Mount the 3rd partition to the data dir
mount /dev/mmcblk0p3 $DATADIR
if [ ! -d $DATADIR/OpenSoarData ]; then
  if ! mount /dev/mmcblk0p3 $DATADIR; then
    if ! mkfs.ext4 /dev/mmcblk0p3; then
      echo "Error 1: mmcblk0p3 couldn't be formatted"  >> $DEBUG_LOG
    fi
    if ! mount /dev/mmcblk0p3 $DATADIR; then
      echo "Error 2: mmcblk0p3 couldn't be mounted"  >> $DEBUG_LOG
    fi
  fi
else
  echo "mmcblk0p3 is mounted at '$DATADIR'"  >> $DEBUG_LOG
fi

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

