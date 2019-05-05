require openvario-base-image.bb

IMAGE_ROOTFS_SIZE ?= "3768320"

IMAGE_INSTALL += "\
    xcsoar-testing-fb \
    caltool \
    sensord-testing\
    variod-testing \
"

export IMAGE_BASENAME = "openvario-image-testing"