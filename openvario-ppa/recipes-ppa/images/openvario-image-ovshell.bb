require recipes-core/images/openvario-base-image.bb

#IMAGE_ROOTFS_SIZE ?= "3768320"
IMAGE_ROOTFS_SIZE ?= "1048576"

IMAGE_INSTALL += "\
    xcsoar-testing \ 
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    ovmenu-ng-skripts \
    sensordy \
    variod \
    openvario-autologin \
    less \
    openvario-shell \
    openvario-shell-autostart \
    openvario-compman \
    syncthing \
    rtl-sdr \
    socat \
    dump1090 \
"

export IMAGE_BASENAME = "openvario-image-ovshell"
