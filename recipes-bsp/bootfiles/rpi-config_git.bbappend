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
    
     # Openvario 70 LVDS
    if [ "${MACHINE}" = "ov-cm4-ch70" ]; then
        # Use the machine specific device tree overlay
        echo "# Enable 70 LVDS" >> $CONFIG
        echo "dtoverlay=ov-cm4-ch70" >> $CONFIG
   		echo "dtoverlay=ads7846,cs=0,penirq=24,penirq_pull=2,speed=50000,keep_vref_on=1,invy=1,swapxy=0,pmin=7,pmax=255,xohms=120" >> $CONFIG
        echo "dtparam=xmin=200,xmax=3900,ymin=200,ymax=3900" >> $CONFIG
        echo "dtparam=ant2" >> $CONFIG
    fi
    # Openvario 7 PQ070
    if [ "${MACHINE}" = "ov-cm4-pq70" ]; then
        # Use the machine specific device tree overlay
        echo "# Enable PQ070 Display" >> $CONFIG
        echo "dtoverlay=ov-cm4-pq70" >> $CONFIG
    fi

    echo "# sound driver" >> $CONFIG
    echo "dtoverlay=max98357a, no-sdmode" >> $CONFIG

    echo "# serial interfaces" >> $CONFIG
    echo "dtoverlay=uart2" >> $CONFIG
    echo "dtoverlay=uart3" >> $CONFIG
    echo "dtoverlay=miniuart-bt" >> $CONFIG
}
