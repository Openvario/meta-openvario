require openvario-base-image.bb

# IMAGE_ROOTFS_SIZE ?= "3768320"
# 1024*1024 = 1.048.576
# IMAGE_ROOTFS_SIZE ?= "1048576"

# (1024-64)*1024 = 983.040
IMAGE_ROOTFS_SIZE ?= "983040"

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
