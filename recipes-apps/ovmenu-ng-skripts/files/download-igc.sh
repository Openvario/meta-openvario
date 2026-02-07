#!/bin/sh
#
# transfers.sh
# Data backup transfer script to and from usbstick for Openvario and 
# OpenSoar or XCSoar
#
# Created by lordfolken         2022-02-08
# Enhanced by 7lima & Blaubart  2022-06-19
#
# backups are stored at USB stick at:
# openvario/download/OpenSoarData/ (or ../XCSoarData/)
# uploads to OpenVario are stored at USB stick at:
# openvario/upload/OpenSoarData/ (or ../XCSoarData/)

# Transfer script for Up/Downloading data to usbstick
# echo "Transfer to and from OpenVario and USB Stick"

USB_STICK="/usb/usbstick"
USB_PATH="$USB_STICK/openvario"
TRANSFER_OPTION=download-igc
# TRANSFER_OPTION=download-nmea
MAIN_APP=$2

RSYNC_OPTION=""
DATA_FOLDER="OpenSoarData"
if [ "$MAIN_APP" = "xcsoar" ]; then
  $DATA_FOLDER="XCSoarData"
fi
SOAR_DATA_PATH="/home/root/data/$DATA_FOLDER"
COPY_MODE="-rc"
# echo "MAIN-APPLICATION: '$MAIN_APP'"

case "$TRANSFER_OPTION" in
    download-nmea)
    # ----------
        echo "Syncronizing NMEA files with USB (folder: /NMEA-OpenSoar)"
        SRC_PATH="$SOAR_DATA_PATH/logs/"
        DEST_PATH="$USB_STICK/NMEA-OpenSoar"
        mkdir -p $DEST_PATH
        SRC_FILTER="--include=*.nmea --exclude=*.igc --exclude=*"
        echo filter = ${SRC_FILTER}
        COPY_MODE="-rcx"
        ;;
    download-igc)
    # ----------
        echo "Syncronizing IGC files with USB (folder: /IGC-OpenSoar)"
        SRC_PATH="$SOAR_DATA_PATH/logs/"
        DEST_PATH="$USB_STICK/IGC-OpenSoar"
        mkdir -p $DEST_PATH
        SRC_FILTER="--include=*.igc --exclude=*.nmea --exclude=*"
        echo filter = ${SRC_FILTER}
        COPY_MODE="-rcx"
        ;;
    download-data)
    # ----------
        echo "Syncronizing $DATA_FOLDER with USB "
        SRC_PATH="$SOAR_DATA_PATH"
        DEST_PATH="$USB_PATH/download/$DATA_FOLDER"
        mkdir -p $DEST_PATH
        ;;
    upload-data)
    # ----------
        echo "Copy USB data to $DATA_FOLDER"
        SRC_PATH="$USB_PATH/upload/$DATA_FOLDER"
        if [ ! -d $SRC_PATH ] && [ "$MAIN_APP" = "OpenSoar" ]; then
          echo "Source path does not exist"
          echo "  $SRC_PATH"
          SRC_PATH=$USB_PATH/upload/XCSoarData
        fi
        if [ ! -d $SRC_PATH ]; then
          echo "Source path does not exist"
          echo "  $SRC_PATH"
          SRC_PATH=$USB_PATH/upload/xcsoar
        fi
        DEST_PATH="$SOAR_DATA_PATH"
        ;;
    sync-data)
    # ----------
        echo "Syncronizing USB data with $DATA_FOLDER"
        SRC_PATH="$USB_PATH/upload/$DATA_FOLDER"
        DEST_PATH="$SOAR_DATA_PATH"
        RSYNC_OPTION="--delete"
        ;;
    upload-all)
    # ----------
        echo "Syncronizing complete USB data folder 'upload' with data partition"
        SRC_PATH="$USB_PATH/upload"
        DEST_PATH="$SOAR_DATA_PATH"
        ;;
    *)
    # ----------
        echo "*** ERROR ***!"
        echo 'transfer option '$TRANSFER_OPTION' unknown!'
        exit 1
esac

echo "Transfer-Option: $TRANSFER_OPTION" 
echo "Source:         '$SRC_PATH'"
echo "Destination:    '$DEST_PATH'"

if [ ! -d "$SRC_PATH" ]; then
    echo "*** ERROR ***!"
    echo "Source path does not exist!"
    exit 1
elif [ ! -d "$DEST_PATH" ]; then
    echo "*** ERROR ***!"
    echo "Destination path does not exist!"
    exit 1
fi

if [ -z "$(find "$SRC_PATH" -type f | head -n 1 2>/dev/null)" ]; then
    echo 'No files found !!!'
else
  # We use -c here due to cubieboards not having an rtc clock
    if rsync $COPY_MODE --progress $RSYNC_OPTION "${SRC_PATH}" ${SRC_FILTER} "$DEST_PATH/"; then
        echo 'All files transfered successfully.'
        echo '----------------------------------'
    else
        echo "*** ERROR ***!"
        echo 'An error has occured!'
        exit 1
    fi
fi

# Sync the buffer to be sure data is on disk
sync
echo 'Done !!'
