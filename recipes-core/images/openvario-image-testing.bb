require openvario-base-image.bb

# image size -> 512MB
IMAGE_ROOTFS_SIZE ?= "475136"

IMAGE_INSTALL += "\
    opensoar \
    xcsoar-testing \
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    caltool \
    sensord \
    variod \
    ovmenu-ng \
    tslib-tests \
"

export IMAGE_BASENAME = "openvario-testing"
export IMAGE_TYPE = "-testing"

#    sensord-testing 
#    variod-testing 
