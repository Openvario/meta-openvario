require openvario-base-image.bb

#IMAGE_ROOTFS_SIZE ?= "3768320"
IMAGE_ROOTFS_SIZE ?= "1048576"

IMAGE_INSTALL += "\
    xcsoar-7.0-preview14 \
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-alps \
    caltool \
    sensord-testing\
    variod-testing \
    ovmenu-ng \
    openvario-autologin \
"

export IMAGE_BASENAME = "openvario-image-testing"