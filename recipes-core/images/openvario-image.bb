require openvario-base-image.bb

#IMAGE_ROOTFS_SIZE ?= "3768320"
IMAGE_ROOTFS_SIZE ?= "1048576"

IMAGE_INSTALL += "\
    xcsoar \
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    caltool \
    sensord \
    variod \
    ovmenu-ng \
    openvario-autologin \
"

export IMAGE_BASENAME = "openvario-image"
