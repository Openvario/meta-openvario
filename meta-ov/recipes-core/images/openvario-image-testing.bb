require openvario-base-image.bb

#IMAGE_ROOTFS_SIZE ?= "3768320"
IMAGE_ROOTFS_SIZE ?= "1048576"

IMAGE_INSTALL += "\
    xcsoar-testing \
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    sensord \
    variod-testing \
    ovmenu-ng \
"

export IMAGE_BASENAME = "openvario-image-testing"
