#!/bin/bash

HOME=/home/root

if [ -e "$HOME/recover_data/upgrade.cfg" ]; then
    echo "'upgrade.cfg' exist!!"
    source $HOME/recover_data/upgrade.cfg
    
    # ==================== Brightness ========================
    if [ ! "$BRIGHTNESS" = "" ]; then 
      echo "$BRIGHTNESS" > /sys/class/backlight/lcd/brightness
      echo " [####======] Brightness set to '$BRIGHTNESS'"
    fi
    # =========== Daemons variod, sensord and dropbear.socket(ssh) ====
    # Restore variod, sensord and ssh status 
    for daemon in sensord variod dropbear.socket; do
      case $daemon in 
        dropbear.socket) d_state="$ssh_d";;
        sensord)         d_state="$sensord";;
        variod)          d_state="$variod";;
      esac
      case $d_state in
        enabled)  /bin/systemctl  enable --quiet --now $daemon
                  /bin/systemctl   start --quiet --now $daemon
                  echo " [#####=====] $daemon has been enabled."
                  ;;
        disabled) /bin/systemctl disable --quiet --now $daemon
                  echo " [#####=====] $daemon has been disabled."
                  ;;
      esac
    done
    # ==================== Recover Data ======================
    if [ "$UPGRADE_TYPE" == "2" ]; then 
      if [ ! -d $DATADIR/OpenSoarData ]; then
        # the data dir is new and has to be filled from USB, this stick should be still 
        # available after upgrade
        # This is only the case on an upgrade from old to a new system
        mkdir -p $DATADIR/OpenSoarData
        echo "'data/OpenSoarData'is new and has to be filled..."  >> $DEBUG_LOG
      fi
      if [ ! -d $DATADIR/XCSoarData ]; then
        mkdir -p $DATADIR/OpenSoarData
        echo "'data/XCSoarData'is new and has to be filled..."  >> $DEBUG_LOG
      fi
      file_count=$(find $HOME/.xcsoar -maxdepth 1 -type f | wc -l)
      if (( $file_count > 6 )); then
        rsync -ruvtcE --progress $HOME/.xcsoar/* $DATADIR/OpenSoarData/ \
                    --delete --exclude cache  --exclude logs
        echo "rsync from .xcsoar to $DATADIR/OpenSoarData"  >> $DEBUG_LOG

        rsync -ruvtcE --progress $HOME/.xcsoar/* $DATADIR/XCSoarData/ \
                      --delete --exclude cache  --exclude logs
        sync
        echo "rsync from .xcsoar to $DATADIR/XCSoarData"  >> $DEBUG_LOG
      fi
      rm -rvf $HOME/.xcsoar/*
      if [ -d $HOME/.glider_club ]; then
        mkdir -p $DATADIR/.glider_club
        rsync -ruvtcE --progress $HOME/.glider_club/* $DATADIR/.glider_club/
        sync
        rm -rvf $HOME/.glider_club
      fi
    fi
    # ==================== End ===============================
    mv $HOME/recover_data/upgrade.cfg $HOME/recover_data/_upgrade.cfg
fi

