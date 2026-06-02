require openvario-base-image.bb

# image size -> 512MB
IMAGE_ROOTFS_SIZE ?= "475136"

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
