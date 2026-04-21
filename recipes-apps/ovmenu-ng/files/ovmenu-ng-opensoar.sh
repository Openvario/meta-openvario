#!/bin/bash
# Sourced by ovmenu-ng.sh. Expects: do_shell(), start_app(), main_app

#==============================================================================
#==============================================================================
#==============================================================================

clear
sync

### /usr/bin/OpenVarioBaseMenu 0
start_app
exit_value=$?
while true
do
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
         select_app;;
     201) /sbin/reboot;;
     202) /sbin/poweroff;;
     203) select_app;;
     204) 
        echo "\n"
        echo "Finish OpenSoar with $exit_value"
        error_stop "Stopped before clear in shell!" 
        do_shell ;;
     205) /usr/bin/fw-upgrade.sh ;;
     206) /usr/bin/ov-calibrate-ts.sh ;;
     207)
          ## /usr/bin/OpenVarioBaseMenu
          select_app ;;
     208 | 209)
          ## RESTART, NEWSTART w/o stop!
          ;;
     100 | 0 | 1) 
        select_app ;;
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
   start_app
   exit_value=$?
done

