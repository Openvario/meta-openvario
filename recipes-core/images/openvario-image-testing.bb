require openvario-base-image.bb

#IMAGE_ROOTFS_SIZE ?= "3768320"
IMAGE_ROOTFS_SIZE ?= "1048576"

IMAGE_INSTALL += "\
    xcsoar-testing \
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-alps \
    xcsoar-maps-default \
    caltool \
    sensord-testing\
    variod-testing \
    ovmenu-ng \
    openvario-autologin \
    pulseaudio-server \
"

export IMAGE_BASENAME = "openvario-image-testing"