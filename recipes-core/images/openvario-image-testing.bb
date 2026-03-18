require openvario-base-image.bb

# image size -> 512MB
IMAGE_ROOTFS_SIZE ?= "475136"

IMAGE_INSTALL += "\
    xcsoar-testing \
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    caltool \
    sensord \
    variod \
    ovmenu-ng \
"

IMAGE_INSTALL:append = "${@bb.utils.contains('DISTRO_FEATURES', 'opensoar', ' opensoar-testing', '', d)}"

export IMAGE_BASENAME = "openvario-testing"
export IMAGE_TYPE = "testing"

#    sensord-testing 
#    variod-testing 
