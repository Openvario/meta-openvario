#!/bin/sh
#
# system-info.sh
# System info script gives an overview which packages and which versions are instaled
#
# Created by Blaubart,        2022-02-08
#

# collect info of installed packages, depending of testing or stable version is used
if [ -n "$(opkg list-installed xcsoar-testing)" ]
then
	XCSOAR_VERSION=$(opkg list-installed xcsoar-testing | cut -d ' - ' -f 3)
else
	XCSOAR_VERSION=$(opkg list-installed xcsoar | cut -d '-' -f 2)
fi

if [ -n "$(opkg list-installed sensord-testing)" ] 
then
	SENSORD_VERSION=$(opkg list-installed sensord-testing | cut -d ' - ' -f 3)
else
	SENSORD_VERSION=$(opkg list-installed sensord | cut -d '-' -f 2)
fi

if [ -n "$(opkg list-installed variod-testing)" ] 
then
	VARIOD_VERSION=$(opkg list-installed variod-testing | cut -d ' - ' -f 3)
else
	VARIOD_VERSION=$(opkg list-installed variod | cut -d '-' -f 2)
fi

# collect info of system and more installed packages
IMAGE_VERSION=$(cat /etc/os-release | grep VERSION_ID | cut -d '=' -f 2)
XCSOAR_MAPS_VERSION=$(opkg list-installed xcsoar-maps* | cut -d '-' -f 4)
XCSOAR_MENU=$(opkg list-installed xcsoar-menu* | cut -d '-' -f 3)
IP_ETH0=$(ip route | grep eth0 | head -n 1 | cut -d ' ' -f 8)
MAC=`ip li|grep -A 1 eth0|tail -n 1|cut -d ' ' -f 6`
IP_WLAN=$(ip route | grep wlan0 | head -n 1| cut -d ' ' -f 8)
I2C_TOOLS=$(opkg list-installed i2c-tools | cut -d '-' -f 3)
E2FSPROGS=$(opkg list-installed e2fsprogs | cut -d '-' -f 2)
USB_MODESWITCH=$(opkg list-installed usb-modeswitch | cut -d '-' -f 3)

# collect status of SSH, variod and sensord
if  /bin/systemctl --quiet is-enabled dropbear.socket
then 
	SSH_STATUS=enabled
else 
	SSH_STATUS=disabled
fi

if /bin/systemctl --quiet is-enabled variod
then 
	VARIOD_STATUS=enabled
else 
	VARIOD_STATUS=disabled
fi
	
if /bin/systemctl --quiet is-enabled sensord
then 
	SENSORD_STATUS=enabled
else 
	SENSORD_STATUS=disabled
fi
		
#print info of system and packages
echo ' Image: '$IMAGE_VERSION

if [ -n "$(opkg list-installed xcsoar-testing)" ]
then
	echo ' XCSoar-testing: '$XCSOAR_VERSION
else
	echo ' XCSoar:'$XCSOAR_VERSION
fi

echo ' Maps:'$XCSOAR_MAPS_VERSION
echo ' Menu:'$XCSOAR_MENU

if [ -n "$(opkg list-installed sensord-testing)" ] 
then
	echo ' sensord-testing: '$SENSORD_VERSION
else
	echo ' sensord:'$SENSORD_VERSION
fi

if [ -n "$(opkg list-installed variod-testing)" ] 
then
	echo ' variod-testing: '$VARIOD_VERSION
else
	echo ' variod:'$VARIOD_VERSION
fi

echo ' IP eth0: '$IP_ETH0
echo ' MAC-address eth0: '$MAC
echo ' IP wlan0: '$IP_WLAN
echo -e '\n'
echo ' supplementary packages that are not included\n in every image:'
echo ' i2c-tools:'$I2C_TOOLS
echo ' e2fsprogs:'$E2FSPROGS
echo ' usb-modeswitch:'$USB_MODESWITCH
echo -e '\n'
echo ' Status of SSH, variod and sensord:'
echo ' SSH is '$SSH_STATUS
echo ' variod is '$VARIOD_STATUS
echo ' sensord is '$SENSORD_STATUS