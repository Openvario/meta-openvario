require openvario-base-image.bb

INHIBIT_PACKAGE_DEBUG_SPLIT = '1'
INHIBIT_PACKAGE_STRIP = '1'


# image size -> 512MB
IMAGE_ROOTFS_SIZE ?= "475136"

IMAGE_INSTALL += "\
    xcsoar \
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    caltool \
    sensord \
    variod \
    ovmenu-ng \
"

IMAGE_INSTALL:append:sunxi = " opensoar"

export IMAGE_BASENAME = "openvario-image"
