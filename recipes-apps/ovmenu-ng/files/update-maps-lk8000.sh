#!/bin/bash
MAP_PATH="/usb/usbstick/openvario/maps"
LK8000_MAP_PATH="/home/root/LK8000/_Maps"

if [ -z "$(ls $MAP_PATH/*.LKM 2>/dev/null)" || -z "$(ls $MAP_PATH/*.DEM 2>/dev/null)" ]; then
        echo "No files for update found !!!"
else
        for mapfile in $(find $MAP_PATH -name '*.LKM'); do
                echo $mapfile
                cp $mapfile $LK8000_MAP_PATH
        done

        for mapfile in $(find $MAP_PATH -name '*.DEM'); do
                echo $mapfile
                cp $mapfile $LK8000_MAP_PATH
        done
fi


umount /dev/sda1
