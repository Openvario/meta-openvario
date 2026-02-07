#!/bin/bash

DEBUG_STOP="No"
VERBOSE="Yes"
DIALOGRC=/opt/bin/openvario.rc

# Config
TIMEOUT=3
DIALOG_CANCEL=1

INPUT=/tmp/menu.sh.$$
PARTITION1=/mmc1
PARTITION2=/mmc2
PARTITION3=/mmc3
USB_STICK=/mnt

USB_OPENVARIO=$USB_STICK/openvario

DEBUG_LOG=$USB_OPENVARIO/debug.log

# Target device (typically /dev/mmcblk0):
TARGET=/dev/mmcblk0

# Image file search string:
HOME=/home/root
images=$USB_OPENVARIO/images/O*V*-*.gz
RECOVER_DIR=$HOME/recover_data
RECOVER_PART2=${PARTITION2}${RECOVER_DIR}
HOME_PART2=${PARTITION2}${HOME}
UPGRADE_CFG=$RECOVER_DIR/upgrade.cfg
UPGRADE_CFG2=$RECOVER_PART2/upgrade.cfg
UPGRADE_CFG2_B=$RECOVER_PART2/_upgrade.cfg
UPGRADE_CFG_USB=$USB_OPENVARIO/upgrade.cfg
UPGRADE_TYPE=1

#------------------------------------------------------------------------------
function error_stop(){
    echo "Error-Stop: $1"
    read -p "Press enter to continue"
}

#------------------------------------------------------------------------------
function printv(){
    if [ "$VERBOSE" = "Yes" ]; then
      echo ":: $1"
    fi
}

#------------------------------------------------------------------------------
function debug_stop(){
    if [ "$DEBUG_STOP" = "Yes" ]; then
      echo "Debug-Stop: $1"
      read -p "Press enter to continue"
    else 
      printv "$1"
    fi
}

#------------------------------------------------------------------------------
main_menu () {
while true
do
  ### display main menu ###
  dialog --clear --nocancel --backtitle "OpenVario Recovery Tool" \
  --title "[ M A I N - M E N U ]" \
  --menu "You can use the UP/DOWN arrow keys" 15 50 6 \
  Flash_SDCard   "Write image to SD Card" \
  Backup-Image   "Backup complete Image" \
  Reboot   "Reboot" \
  Exit "Exit to shell" \
  ShutDown "ShutDown... " \
    2>"${INPUT}"
   
  menuitem=$(<"${INPUT}")
 
  # make decsion 
case $menuitem in
  Flash_SDCard) select_image;;
  Backup-Image) backup_image;;
  Reboot) /opt/bin/reboot.sh;;
  Exit) /bin/bash;;
  ShutDown) shutdown -h now;;
esac

done
}

#------------------------------------------------------------------------------
function backup_image(){
  if [ -d "$USB_OPENVARIO" ]; then
    local datestring=$(date +%F)
    mkdir -p $USB_OPENVARIO/backup
    # backup 1GB
    # test backup 50MB (Boot areal + 10 MB)
    local blocksize=1024
    dd if=/dev/mmcblk0 bs=$blocksize | gzip > $USB_OPENVARIO/backup/img_$datestring.img.gz | \
       dialog --gauge "Backup Image ... " 10 50 0
    echo "Backup finished"
  else
    error_stop "No OpenVario USB stick found!"
  fi
}

#------------------------------------------------------------------------------
function select_image() {
  # This has to be done because error '/dev/fd/63: No such file or directory'
  ln -s /proc/self/fd /dev/fd
  
  let count=0 # define counting variable
  files=()        # define file array 
  files_nice=()   # define array with index + file description for dialogdialog
  search_array=()

  if [ -d "$PARTITION3/images" ]; then
    search_array+=("$PARTITION3"  "(data)")
  fi
  if [ -d "$HOME_PART2/images" ]; then
    search_array+=("$HOME_PART2"  "(intern)")
  fi
  search_array+=("$USB_OPENVARIO"  "(USB)")
  
  echo "count pathes ${#search_array[*]}"
  for ((i=0; i<${#search_array[*]}; i=i+2)); do
    images=${search_array[$i]}/images/O*V*-*.gz
    extension=${search_array[$i+1]}
    echo "$images:        $extension"
    #--------------------------------------------------------------------------
    while read -r line; do
      # process file by file
        let count=$count+1
        files+=($count "$line")
        filename=$(basename "$line") 
        temp1=$(echo $filename | grep -oE '[0-9]{5}')
        if [ -n "$temp1" ]; then
            teststr=$(echo $filename | awk -F'-ipk-|.rootfs' '{print $2}')
            # teststr is now: 17119-openvario-57-lvds[-testing]
            temp2=$(echo $teststr | awk -F'-openvario-|-testing' '{print $2}')
        else
            # the complete (new) filename without extension
            # temp1=$(echo $filename | awk -F'/|.img' '{print $4}')
            temp1=${filename}
        fi
        # grep the buzzword 'testing'
        temp3=$(echo $filename | grep -o "testing")
        
        if [ -n "$temp2" ]; then
            temp="$temp1 hw=$temp2"
        else
            temp="$temp1"
        fi
        if [ -n "$temp3" ]; then
            temp="$temp ($temp3)"
        fi
        files_nice+=($count "$temp $extension") # selection index + name
    done < <( ls -1 $images )
  done
#------------------------------------------------------------------------------
  if [ -n "$files" ]; then
      dialog --backtitle "Selection upgrade image from file list" \
      --title "Select image" \
      --menu "Use [UP/DOWN] keys to move, ENTER to select" \
      18 60 12 "${files_nice[@]}" 2>"${INPUT}"
      
      read SELECTED < ${INPUT}
      let INDEX=$SELECTED+$SELECTED-1  # correct pointer in the arrays
      IMAGEFILE="${files[$INDEX]}"
      echo "-------------------------"
      echo "SELECTED  = ${files_nice[$INDEX]}"
      echo "IMAGEFILE = $IMAGEFILE"

    TITLE="File:  $IMAGEFILE"
    # Show Image write options
    dialog --backtitle "${TITLE}" \
    --title "Select update method" \
    --menu "Use [UP/DOWN] keys to move, ENTER to select" \
    18 60 12 \
    "UpdateAll"     "Update complete SD Card" \
    "UpdateuBoot"     "Update Bootloader only" \
    2>"${INPUT}"
    
    menuitem=$(<"${INPUT}")
 
    # make decsion 
    case $menuitem in
        UpdateuBoot) updateuboot;;
        UpdateAll) updateall;;
    esac

  else
      error_stop "no image file(s) found"
      IMAGEFILE=""
  fi
}

#------------------------------------------------------------------------------
# update rootfs on mmcblk0
function updaterootfs(){
    
  (pv -n ${IMAGEFILE} | gunzip -c | dd bs=1024 skip=1024 | dd of=$TARGET bs=1024 seek=1024) 2>&1 | dialog --gauge "Writing Image ... " 10 50 0
    
}

#------------------------------------------------------------------------------
function notimplemented(){

  dialog --backtitle "${TITLE}" \
      --msgbox "Not implemented yet !!" 10 60
}

#------------------------------------------------------------------------------
function bootloader_check_and_restore(){
  BOOT_LOADER=$RECOVER_PART2/boot_recover.img.gz
  if [ -f $BOOT_LOADER ]; then
    # restore boot loader part in old fw!
    gzip -cfd $BOOT_LOADER | dd of=$TARGET bs=4096 seek=10 count=112
    sync
    # delete this at the end:
    rm -f $BOOT_LOADER
  fi
}

#------------------------------------------------------------------------------
# update uboot
function updateuboot(){
    
  #gunzip -c $(cat selected_image.$$) | dd of=$TARGET bs=1024 count=1024  
  (pv -n ${IMAGEFILE} | gunzip -c | dd of=$TARGET bs=1024 count=1024) 2>&1 | dialog --gauge "Writing Image ... " 10 50 0
}

#update updateall
#------------------------------------------------------------------------------
function updateall(){
  umount $PARTITION1
  umount $PARTITION2
  if [ -d "$PARTITION3/OpenSoarData" ]; then
    umount $PARTITION3
  fi 

  sync
  echo "Upgrade with '${IMAGEFILE}'"  >> $DEBUG_LOG
  IMAGE_NAME="$(basename $IMAGEFILE .gz)"
  (pv -n ${IMAGEFILE} | gunzip -c | dd of=$TARGET bs=16M) 2>&1 | \
    dialog --gauge "Writing Image ...\nfile = ${IMAGE_NAME}  " 10 50 0
  #########################################
  # remove the recovery file:
  echo "Upgrade '${IMAGEFILE}' finished"  >> $DEBUG_LOG
}

#------------------------------------------------------------------------------
function create_mmcblkp3(){
# Start at 1.2GB:
PARTITION3_START=2359296
# End at default (= maximum):
PARTITION3_END=

fdisk /dev/mmcblk0 << EOF
p
n
p
3
${PARTITION3_START}
${PARTITION3_END}
p
w
EOF
}
#------------------------------------------------------------------------------
# this function should be stored in update-system-config.sh (called from 
# ovmennu-ng.sh, but should be also used in older firmware too...
# maybe insert this script in the openvario-recovery-image!
# # The function make no sense here, because system services not started yet
function restore_settings() {
  # ... content from update-system-config.sh
  if [ ! -f $PARTITION2/usr/bin/update-system-config.sh ]; then # => UPDATE_TYPE 2 and 4
    if [  -f $USB_OPENVARIO/update-system-config.sh ]; then
      cp -f $USB_OPENVARIO/update-system-config.sh $PARTITION2/usr/bin/
      chmod 757 $PARTITION2/usr/bin/update-system-config.sh
      # chown root:root $PARTITION2/usr/bin/update-system-config.sh
    fi
    # copy also fw-upgrade.sh in the usr/bin dir too
    if [  -f $USB_STICK/fw-upgrade.sh ]; then
      cp -f $USB_STICK/fw-upgrade.sh $PARTITION2/usr/bin/
      chmod 757 $PARTITION2/usr/bin/fw-upgrade.sh
      # chown root:root $PARTITION2/usr/bin/update-system-config.sh
    fi
  fi
}
#------------------------------------------------------------------------------
function recover_system(){
  # source $UPGRADE_CFG  # again not necessary!
    # 1 - from new fw to new fw
    # 2 - from old fw to new fw
    # 3 - from new fw to old fw
    # 4 - from old fw to old fw
  case "$UPGRADE_TYPE" in
  1)   echo "restore 3rd partition 'ov-data'"
       echo "------------------------------"
       # debug: read -p "Press enter to continue"
       # source $PARTITION2/usr/bin/create_datapart.sh
       create_mmcblkp3
       debug_stop "Partition 3 created"
       sync
       if mount ${TARGET}p3 $PARTITION3; then
         debug_stop "Partition 3 is already mounted :)"
       else
         echo "Error 2: mmcblk0p3 couldn't be mounted"  >> $DEBUG_LOG
         error_stop "Error 2: mmcblk0p3 couldn't be mounted!"
       fi
       mount ${TARGET}p2  $PARTITION2
       ;;
  2) echo "create 3rd partition 'ov-data'"
       echo "------------------------------"
       # debug: read -p "Press enter to continue"
       # source $PARTITION2/usr/bin/create_datapart.sh
       create_mmcblkp3
       debug_stop "Partition 3 created"
       # partition 3 mount dir '$PARTITION3' is not created up to now!
       mkdir -p $PARTITION3
       mount ${TARGET}p3 $PARTITION3
       if mount | grep ${TARGET}p3 > /dev/null; then
         mount ${TARGET}p2  $PARTITION2  # after partition 3!
         echo "Partition 3 exist from a previous firmware "
         debug_stop "Partition 3 is already mounted :)"

         # OpenSoarData:
         if [ -d  $PARTITION3/OpenSoarData ]; then
           rm -vfr $PARTITION3/OpenSoarData/*  # delete complete content
         else
           mkdir -p $PARTITION3/OpenSoarData
         fi
         if [ -d  $RECOVER_DIR/xcsoar ]; then
           cp -vfr $RECOVER_DIR/xcsoar/* $PARTITION3/OpenSoarData/
         else
           cp -vfr $HOME_PART2/.xcsoar/* $PARTITION3/OpenSoarData/
         fi

         # XCSoarData:
         if [ -d  $PARTITION3/XCSoarData ]; then
           rm -vfr $PARTITION3/XCSoarData/*  # delete complete content
         else
           mkdir -p $PARTITION3/XCSoarData
         fi
         if [ -d  $RECOVER_DIR/xcsoar ]; then
           cp -vfr $RECOVER_DIR/xcsoar/* $PARTITION3/XCSoarData/ 
         else
           cp -vfr $HOME_PART2/.xcsoar/* $PARTITION3/XCSoarData/
         fi
         
         # .glider_club:
         if [ -d $RECOVER_DIR/glider_club ]; then
            mkdir -p $PARTITION3/.glider_club
            cp -vfr $RECOVER_DIR/glider_club/* $PARTITION3/.glider_club/
         fi
       else
         echo "Error 2: mmcblk0p3 couldn't be mounted"  >> $DEBUG_LOG
         debug_stop "Error 2: mmcblk0p3 couldn't be mounted!"
         # try to format with ext4 immediately?
         mkfs.ext4 ${TARGET}p3
         sync
         mount ${TARGET}p3 $PARTITION3
         mount ${TARGET}p2 $PARTITION2  # after partition 3!
         if mount | grep ${TARGET}p3 > /dev/null; then
            #  if mount ${TARGET}p3 $PARTITION3; then
            mkdir -p $PARTITION3/OpenSoarData
            cp -rfv $RECOVER_DIR/xcsoar/* $PARTITION3/OpenSoarData/
            mkdir -p $PARTITION3/XCSoarData
            cp -rfv $RECOVER_DIR/xcsoar/* $PARTITION3/XCSoarData/
            mv -fv $RECOVER_DIR/xcsoar $RECOVER_DIR/_xcsoar
            if [ -d "$RECOVER_DIR/glider_club" ]; then
               mv -fv $RECOVER_DIR/glider_club $PARTITION3/.glider_club
            fi
          else
            echo "Error 2: mmcblk0p3 couldn't be mounted"  >> $DEBUG_LOG
            error_stop "Error 2: mmcblk0p3 couldn't be mounted"
            mv -f $HOME_PART2/.xcsoar $HOME_PART2/_xcsoar 
            rm -rf $HOME_PART2/_xcsoar
            sync
            mv -fv $RECOVER_DIR/xcsoar $HOME_PART2/.xcsoar
            if [ -d "$RECOVER_DIR/glider_club" ]; then
               mv -fv $RECOVER_DIR/glider_club $HOME_PART2/.glider_club
            fi
         fi
       fi
       sync
       debug_stop "old to new"
       ;;
  3 | 4)  echo "target is old type - data (copy) in .xcsoar"
       echo "------------------------------"
       debug_stop "old or new fw to old"
       mount ${TARGET}p2  $PARTITION2
       # delete the standard data from image:
       mv -f $HOME_PART2/.xcsoar $HOME_PART2/_xcsoar 
       rm -rf $HOME_PART2/_xcsoar
       sync
       mv -fv $RECOVER_DIR/xcsoar $HOME_PART2/.xcsoar
       if [ -f $USB_OPENVARIO/update-system-config.sh ]; then 
         cp -fv $USB_OPENVARIO/update-system-config.sh $HOME_PART2/
       fi
       # copy also fw-upgrade.sh in the HOME dir too
       if [ -f $USB_STICK/fw-upgrade.sh ]; then 
         cp -fv $USB_STICK/fw-upgrade.sh $HOME_PART2/
       fi
       # copy also ov-recovery.itb in the USR_BIN dir too
       if [ -f $USB_OPENVARIO/images/$TARGET_HW/ov-recovery.itb ]; then 
         cp -fv $USB_OPENVARIO/images/$TARGET_HW/ov-recovery.itb \
                $PARTITION2/usr/bin/
       fi
       if [ -d "$RECOVER_DIR/glider_club" ]; then
          mv -fv $RECOVER_DIR/glider_club $HOME_PART2/.glider_club
       fi
       ;;
  *)   echo "unknown UPGRADE_TYPE '$UPGRADE_TYPE'"  >> $DEBUG_LOG
       error_stop "unknown UPGRADE_TYPE '$UPGRADE_TYPE'"
       ;;
  esac
  # remounting
  mount ${TARGET}p1  $PARTITION1
  # recover OpenSoarData:
  if [ -d "$RECOVER_DIR" ]; then
    if [ -f "$RECOVER_DIR/config.uEnv" ]; then
      source $RECOVER_DIR/config.uEnv
      echo "sdcard/config.uEnv"      >> $DEBUG_LOG
      echo "------------------------"      >> $DEBUG_LOG
      echo "rotation      = $rotation"     >> $DEBUG_LOG
      echo "brightness    = $brightness"   >> $DEBUG_LOG
      echo "font          = $font"         >> $DEBUG_LOG
      echo "fdt           = $fdtfile"      >> $DEBUG_LOG
      echo "========================"      >> $DEBUG_LOG
    
      if [ -n "$ROTATION" ]; then
          if [ "$DISPLAY_ROTATION" = "Yes" ]; then
            case $ROTATION in 
            1) ROTATION=3;;
            3) ROTATION=1;;
            2 | 4 | *) ;;  # do nothing:
            esac
          fi
      fi
      echo "$UPGRADE_CFG"                >> $DEBUG_LOG
      echo "------------------"           >> $DEBUG_LOG
      echo "ROTATION      = $ROTATION"    >> $DEBUG_LOG
      echo "BRIGHTNESS    = $BRIGHTNESS"  >> $DEBUG_LOG
      echo "FONT          = $FONT"        >> $DEBUG_LOG
      echo "SSH           = $SSH"         >> $DEBUG_LOG
      echo "========================"     >> $DEBUG_LOG
      if [ -n "$ROTATION" ]; then
          sed -i 's/^rotation=.*/rotation='$ROTATION'/' $PARTITION1/config.uEnv
      fi
      if [ -n "$BRIGHTNESS" ]; then
        count=$(grep -c "brightness" $PARTITION1/config.uEnv)
        if [ "$count" = "0" ]; then 
          echo "brightness=$BRIGHTNESS" >> $PARTITION1/config.uEnv
          echo "Set BRIGHTNESS (3) '$BRIGHTNESS' NEW"  >> $DEBUG_LOG
        else
          sed -i 's/^brightness=.*/brightness='$BRIGHTNESS'/' $PARTITION1/config.uEnv
          echo "Set BRIGHTNESS (4) '$BRIGHTNESS' UPDATE"  >> $DEBUG_LOG
        fi
      fi
    fi

    # restore the bash history:
    cp -fv  $RECOVER_DIR/.bash_history $HOME_PART2/
    
    if [ -f "$RECOVER_DIR/system-data.tar.gz" ]; then
      tar -zxf $RECOVER_DIR/system-data.tar.gz --directory $PARTITION2/
    fi

    ## This is not possible yet! Wait until system restart... :(
    # now this function is copying the update-system-config.sh in
    # directory /usr/bin for later use!
    restore_settings "$RECOVER_DIR" "$PARTITION2"

    # copy back to /partition2/home/root:
    cp -fvr $RECOVER_DIR   $HOME_PART2/
    
    ls -l $HOME_PART2/.xcsoar >> $DEBUG_LOG
    echo "ready OV upgrade!"
    echo "ready OV upgrade!"  >> $DEBUG_LOG
  else
    echo "' $RECOVER_DIR' doesn't exist!"
    echo "' $RECOVER_DIR' doesn't exist!"  >> $DEBUG_LOG
  fi

  echo "UPGRADE_TYPE = '$UPGRADE_TYPE'"  >> $DEBUG_LOG
  if [ -z $UPGRADE_TYPE ]; then 
     echo "UPGRADE_TYPE is set to '0000'"  >> $DEBUG_LOG
     UPGRADE_TYPE=0;
  fi

  echo "Upgrade ready"  >> $DEBUG_LOG
  # set dmesg kernel level back to the highest:
  if [ -d "$USB_OPENVARIO" ]; then 
    dmesg -n 8
    dmesg > $USB_OPENVARIO/dmesg.txt
    gzip -f $USB_OPENVARIO/dmesg.txt
  fi

  umount $PARTITION1
  umount $PARTITION2
  if [ -d "$PARTITION3/OpenSoarData" ]; then
    umount $PARTITION3
  fi 
  #last step:
  echo "*************************************************" >> $DEBUG_LOG
  cp -fv $DEBUG_LOG $RECOVER_PART2/

  sync

#################################
  MENU_TITLE="$MENU_TITLE\nUpgrade is finished!"
  MENU_TITLE="$MENU_TITLE\nDo you want to restart the system?"
  MENU_TITLE="$MENU_TITLE\n=================================="
  MENU_TITLE="$MENU_TITLE\nPress [ESC] to cancel!"
  # BACKTITLE="Finishing the Upgrade" \
  # TITLE="Upgrade finished" \
  TIMEOUT=4
  dialog --nook --nocancel --pause \
  "$MENU_TITLE" 20 60 $TIMEOUT 2>&1
  # DO NOTHING AFTER USING '$?' ONE TIMES!!!
  # but store the selection for debug reasons:
  INPUT="$?"
  if [ ! "$INPUT" = "0" ]; then
    echo "No reboot because Escape!"
    debug_stop "INPUT was $INPUT"
    exit
  else
    /opt/bin/reboot.sh
  fi 
}

#------------------------------------------------------------------------------
function update_system() {
  echo "Updating System ..." > /tmp/tail.$$
  /usr/bin/update-system.sh >> /tmp/tail.$$ &
  dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

#------------------------------------------------------------------------------
function save_old_system() {
    # 2nd: save boot folder to Backup from partition 1
    echo "2nd: save boot folder to Backup from partition 1"
    # -d is invalid option? rm -fr $RECOVER_DIR

    echo "  copy command ..."
    # cp is available on all (old) firmware
    # copy only files from interest (no picture, no uImage) 
    cp -fv  $PARTITION1/config.uEnv        $RECOVER_DIR/
    cp -fv  $PARTITION1/image-version-info $RECOVER_DIR/

    # 3rd: save OpenSoarData/XCSoarData from partition 2 (or 3):
    echo "3rd: save OpenSoarData / XCSoarData from partition 2 or 3"
    debug_stop "UPGRADE_TYPE = $UPGRADE_TYPE"

    CLUB_DIR=""
    case "$UPGRADE_TYPE" in 
      3)  # data coming from 'data/OpenSoarData' folder
          echo "data coming from 'data/OpenSoarData' folder for upgrade type $UPGRADE_TYPE"
          mkdir -p $RECOVER_DIR/xcsoar
          if [ ! -d "$PARTITION3/OpenVarioData" ]; then
            mount ${TARGET}p3 $PARTITION3
          fi
          if [ -d  $PARTITION3/OpenSoarData ]; then
            # unfortunately RSYNC is not available in ov-recovery.itb!
            cp -rfv  $PARTITION3/OpenSoarData/* $RECOVER_DIR/xcsoar/
            # or ? cp -rfv  $PARTITION3/XCVarioData/* $RECOVER_DIR/xcsoar/
            # the old image type has a reduced data memory
            rm -rf $RECOVER_DIR/xcsoar/logs/
            rm -rf $RECOVER_DIR/xcsoar/cache/
          else
            error_stop "OpenSoarData doesn't exist!"
          fi
          
          CLUB_DIR="$PARTITION3/.glider_club"
          debug_stop "OpenSoarData are copied in '$RECOVER_DIR/xcsoar'"
        ;;
      2 | 4) # data coming from '.xcsoar' folder
          echo "data coming from '.xcsoar' folder for upgrade type $UPGRADE_TYPE"
          mkdir -p $RECOVER_DIR/xcsoar
          cp -rfv  $HOME_PART2/.xcsoar/* $RECOVER_DIR/xcsoar/
          CLUB_DIR="$HOME_PART2/.glider_club"
          debug_stop "xcsoar data are copied in '$RECOVER_DIR/xcsoar'"
        ;;
      1|*) 
          debug_stop "Nothing to do for new firmwares!"
        ;;
    esac
    cp -fv   $HOME_PART2/.bash_history $RECOVER_DIR/
    
    #---------------------------------------
    MAIN_DIR=$(pwd)
    cd $PARTITION2/
    ZIP_FILES="var/lib/connman"
    if [ -f etc/udev/rules.d/libinput-ts.rules ]; then ZIP_FILES+=" etc/udev/rules.d/libinput-ts.rules"; fi
    if [ -f etc/udev/rules.d/touchscreen.rules ]; then ZIP_FILES+=" etc/udev/rules.d/touchscreen.rules"; fi
    if [ -f opt/conf/sensord.conf ];              then ZIP_FILES+=" opt/conf/sensord.conf"; fi
    if [ -f opt/conf/variod.conf ];               then ZIP_FILES+=" opt/conf/variod.conf"; fi
    
    # check if necessary:
    if [ -f etc/pointercal ];                     then ZIP_FILES+=" etc/pointercal"; fi
    if [ -f etc/dropbear ];                       then ZIP_FILES+=" etc/dropbear"; fi
    
    # not necessary:
    #  if [ -f etc/locale.conf ];   - not needed
    #  if [ -d home/root ];         - extra handler
    #  if [ -f boot/config.uEnv ];  - extra handler
    
    echo $ZIP_FILES
    tar cvf - $ZIP_FILES | gzip >$RECOVER_DIR/system-data.tar.gz
    
    GZIP_EXIT=$?
    cd $MAIN_DIR
    #---------------------------------------
    if [ -d "$CLUB_DIR" ]; then
        echo "save gliderclub data from partition 2"
        mkdir -p $RECOVER_DIR/glider_club
        cp -frv $CLUB_DIR/* $RECOVER_DIR/glider_club/
    fi
    
    debug_stop "saving finished"
    # Synchronize the commands (?)
    sync
    if [ -d "$PARTITION3/OpenVarioData" ]; then
      umount $PARTITION3
    fi
}

#------------------------------------------------------------------------------
function check_old_image_type() {
  if [ ! -f $PARTITION1/*.dtb ]; then
    # very old image type (f.e. 17119)
    source $PARTITION1/config.uEnv
    case "$rotation" in
      1)  new_rot=3;;
      3)  new_rot=1;;
    esac
    if [ -n "$new_rot" ]; then
      clear
      echo "$new_rot" >/sys/class/graphics/fbcon/rotate_all
      debug_stop "rotate the display at this old image type to '$new_rot'!"
    fi
  fi
}

#==============================================================================
#==============================================================================
#==============================================================================
#                Update - Begin
echo "Upgrade Start"
####################################################################

#---------------------------------------------------------
if [ -z "$1" ]; then
  if [ ! "$0" = "$HOME/ovmenu-recovery.sh" ]; then
    # Call another ovmenu-recovery.sh to change it 'on the fly'
    if [ -f "$USB_OPENVARIO/ovmenu-recovery.sh" ]; then 
      TIMEOUT=6
      dialog --nook --nocancel --pause \
      "Do you want to use the alternate 'ovmenu-recovery.sh'" 20 60 $TIMEOUT 2>&1
      # DO NOTHING AFTER USING '$?' ONE TIMES!!!
      # but store the selection for debug reasons:
      INPUT="$?"
      if [ "$INPUT" = "0" ]; then
        # ENTER or TIMEOUT:
        cp "$USB_OPENVARIO/ovmenu-recovery.sh" $HOME/
        chmod 757 $HOME/ovmenu-recovery.sh
        error_stop " call alternative '$HOME/ovmenu-recovery.sh'"
        $HOME/ovmenu-recovery.sh  "New Start"
        exit
        debug_stop " exit after '$HOME/ovmenu-recovery.sh'"
      fi 
    fi
  else
    debug_stop "new ovmenu-recovery.sh - 2"
  fi
else
  debug_stop "new ovmenu-recovery.sh - 1"
fi

echo "==================================================="
echo "==================================================="
echo "==================================================="
echo "==================================================="
echo "==================================================="
debug_stop " and now it's starting the upgrade!"

#---------------------------------------------------------
# trap and delete temp files
trap "rm $INPUT;rm /tmp/tail.$$; exit" SIGHUP SIGINT SIGTERM

# delete ov-recovery.itb independent from success!
# debug_stop "... and begin..."
# ??? setfont cp866-8x14.psf.gz

#delete ov-recovery.itb from Usb stick (usb/openvario/ov-recovery.itb):
rm -f $USB_OPENVARIO/ov-recovery.itb  >/dev/null 2>&1

mkdir -p $PARTITION1
mkdir -p $PARTITION2

mount ${TARGET}p1  $PARTITION1
check_old_image_type
mount ${TARGET}p2  $PARTITION2
#delete ov-recovery.itb in the home dir too:
rm -f $HOME_PART2/ov-recovery.itb  >/dev/null 2>&1
if [ "$?" = "0" ]; then 
  debug_stop "'${TARGET}p2 is mounted' "
else
  error_stop "'${TARGET}p2 IS NOT MOUNTED!!!' "
  exit
fi
bootloader_check_and_restore

# ov-recovery.itb will be overwritten with dd
mkdir -p $RECOVER_DIR
# 1st search on USB (if manually defined upgrade.cfg)
if [ -f "$UPGRADE_CFG_USB" ]; then
  echo "'$UPGRADE_CFG_USB' found"
  cp -fv "$UPGRADE_CFG_USB" "$UPGRADE_CFG"
  source $UPGRADE_CFG
  mv "$UPGRADE_CFG_USB" "$USB_OPENVARIO/_upgrade.cfg"
# 2nd search on (mmc2)HOME (if upgrade.cfg coming from fw-upgrade.sh)
elif [ -f "$UPGRADE_CFG2" ]; then
  echo "'$UPGRADE_CFG2' found"
  cp -fv "$UPGRADE_CFG2" "$UPGRADE_CFG"
  source $UPGRADE_CFG
elif [ -f "$UPGRADE_CFG2_B" ]; then
  # in this case use 
  echo "'$UPGRADE_CFG2_B' found"
  cp -fv "$UPGRADE_CFG2_B" "$UPGRADE_CFG"
  error_stop "Using old backup config '$UPGRADE_CFG2_B'?"
  source $UPGRADE_CFG
else
  error_stop "'$UPGRADE_CFG2' NOT found!"
fi 
if [ -f "$UPGRADE_CFG" ]; then
  echo "AugTest: Upgrade-Config: $UPGRADE_CFG "
  debug_stop "Upgrade-Image: $IMAGEFILE "
else
  error_stop "No Upgrade-Config found! "
fi 

# make recover_data dir in HOME and copy the data in 
# $RECOVER_PART2 will be overwritten later...
cp -rfv $RECOVER_PART2/*  $RECOVER_DIR 
DEBUG_LOG=$RECOVER_DIR/debug.log
debug_stop "'copy recover_data' done!"
  # if [ -d $PARTITION2/home/root/recover_data ]; then
  # fi
#-----------------------------------------------------

#check and mount partition 3:
case "$UPGRADE_TYPE" in
  1 | 3)
    if [ -b "${TARGET}p3" ]; then
      mkdir -p $PARTITION3
      mount ${TARGET}p3  $PARTITION3
      debug_stop "$PARTITION3 is mounted"
      sync
      # ls $PARTITION3/
      debug_stop "$PARTITION3 is mounted!!!!"
    else 
      debug_stop "No $PARTITION3!!"
      error_stop "No $PARTITION3!!!!!!!!!!!!!!!!!!!"
    fi
    ;;
  2 | 4) 
    echo "On older systems no partition 3 available!"
  ;;
  *) 
   error_stop "Wrong UPGRADE_TYPE = $UPGRADE_TYPE"
  ;;
esac

# DEBUG_LOG=$USB_OPENVARIO/debug.log
echo "Upgrade start"  > $DEBUG_LOG
date %Y-%m-%d %H:%M:%S >> $DEBUG_LOG
date %Y-%m-%d %H:%M:%S
echo "----------------------------------------"

echo "List: '$HOME'"
ls $HOME
echo "List: '$RECOVER_DIR'"
ls $RECOVER_DIR

# image file name with path!
if [ -f $PARTITION3/images/$IMAGEFILE ]; then
  # copy it from sd card to ramdisk!
  # NO LINK: later mmcblk0 is overwritten
  # maybe this isn't necessary?
  cp "$PARTITION3/images/$IMAGEFILE" $HOME/
  IMAGEFILE="$HOME/$IMAGEFILE"
  sync
elif [ -f $USB_OPENVARIO/images/$IMAGEFILE ]; then
  IMAGEFILE="$USB_OPENVARIO/images/$IMAGEFILE"
else
  IMAGEFILE+=" (Not available!)"
fi

echo "Detected image file: '$IMAGEFILE'!"  >> $DEBUG_LOG
debug_stop "Detected image file: '$IMAGEFILE'!"


if [ -f "$IMAGEFILE" ]; then
  printv "IMAGEFILE          = '$IMAGEFILE' "
  printv "======================================"
  printv "SSH                = $SSH"
  printv "BRIGHTNESS         = $BRIGHTNESS"
  printv "ROTATION           = $ROTATION"
  printv "HARDWARE_BASE      = $HARDWARE_BASE"
  printv "FIRMWARE_BASE      = $FIRMWARE_BASE"
  printv "HARDWARE_TARGET    = $HARDWARE_TARGET"
  printv "FIRMWARE_TARGET    = $FIRMWARE_TARGET"
  printv "UPGRADE_TYPE       = $UPGRADE_TYPE"
fi

# set dmesg minimum kernel level:
dmesg -n 1

if [ -f "$IMAGEFILE" ]; then
  echo "Update $IMAGEFILE !!!!"
  save_old_system
  updateall
  recover_system
else
  clear
  if [ -z "$IMAGEFILE" ]; then
    error_stop "IMAGEFILE is empty, please select image from USB!"
  else
    error_stop "'$IMAGEFILE' don't exist, please select image from USB!"
  fi
  main_menu
fi

#=====================================================================================
#=====================================================================================
#=====================================================================================
