#!/bin/bash

#mount emmc
echo "Mounting eMMC flash ..."
mkdir -p /mmc
mount /dev/mmcblk0p2 /mmc

# links emmc config dir to local filesystem
ln -s /mmc/opt/conf /opt/conf

#backup config to usb stick
echo "Restoreing config ..."
/opt/bin/cfgmgr.py -p /mmc/etc/cfgmgr.d -b /mnt/openvario/config restore all

#unmount emmc
echo "Unmount eMMC flash ..."
umount /mmc
