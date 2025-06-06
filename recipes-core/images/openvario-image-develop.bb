require openvario-base-image.bb

#IMAGE_ROOTFS_SIZE ?= "3768320"
IMAGE_ROOTFS_SIZE ?= "1048576"

IMAGE_INSTALL += "\
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    caltool \
    sensord \
    variod \
    ovmenu-ng \
    dtc \
    i2c-tools \
    raspi-gpio \
    xcsoar \
"
#   xcsoar 
export IMAGE_BASENAME = "openvario-image-develop"
