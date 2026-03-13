# Appends the config.txt used in the Rapsberry PI boot process to adapt Openvario
# relevant changes

do_deploy:append () {

	CONFIG=${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt

     # Openvario 57 LVDS
    if [ "${MACHINE}" = "ov-rpi4-64" ]; then
        # Use the machine specific device tree overlay
        echo "# Enable 57 LVDS" >> $CONFIG
        echo "dtoverlay=ov-rpi4-ch57" >> $CONFIG
    fi
    
     # Openvario 57 LVDS
    if [ "${MACHINE}" = "ov-cm4-ch57" ]; then
        # Use the machine specific device tree overlay
        echo "# Enable 57 LVDS" >> $CONFIG
        echo "dtoverlay=ov-cm4-ch57" >> $CONFIG
    fi

    # Openvario 7 PQ070
    if [ "${MACHINE}" = "ov-cm4-pq70" ]; then
        # Use the machine specific device tree overlay
        echo "# Enable PQ070 Display" >> $CONFIG
        echo "dtoverlay=ov-cm4-pq70" >> $CONFIG
    fi

    echo "# sound driver" >> $CONFIG
    echo "dtoverlay=max98357a" >> $CONFIG

    echo "# serial interfaces" >> $CONFIG
    echo "dtoverlay=uart2" >> $CONFIG
    echo "dtoverlay=uart3" >> $CONFIG
}