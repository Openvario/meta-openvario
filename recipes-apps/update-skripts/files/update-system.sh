#!/bin/bash

opkg update >> /dev/null

OPKG_OUT=$(opkg list-upgradable)


if [ -z "$OPKG_OUT" ]
then
	echo "No upgradable packages found !"
	read -t 5 -p "Hit ENTER to continue or wait 5 seconds ..."
	exit
fi

echo $OPKG_OUT
read -p "Are you sure you want to upgrade ? " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -e "\nUpdating system ..."
	opkg upgrade
fi
