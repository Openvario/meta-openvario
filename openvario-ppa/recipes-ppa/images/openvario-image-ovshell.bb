require recipes-core/images/openvario-base-image.bb

#IMAGE_ROOTFS_SIZE ?= "3768320"
IMAGE_ROOTFS_SIZE ?= "1048576"

IMAGE_INSTALL += "\
    xcsoar \
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    ovmenu-ng-skripts \
    sensord \
    variod \
    less \
    openvario-shell \
    openvario-shell-autostart \
    openvario-compman \
    syncthing \
    ntp \
    kedder-opkg-feed \
"

export IMAGE_BASENAME = "openvario-image-ovshell"
