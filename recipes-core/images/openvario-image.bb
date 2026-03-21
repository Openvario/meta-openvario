require openvario-base-image.bb

INHIBIT_PACKAGE_DEBUG_SPLIT = '1'
INHIBIT_PACKAGE_STRIP = '1'

# Check that xcsoar and opensoar are not both enabled
python do_check_soar_features() {
    import bb
    xcsoar = bb.utils.contains('DISTRO_FEATURES', 'xcsoar', True, False, d)
    opensoar = bb.utils.contains('DISTRO_FEATURES', 'opensoar', True, False, d)
    if xcsoar and opensoar:
        bb.fatal("Both 'xcsoar' and 'opensoar' cannot be enabled in DISTRO_FEATURES at the same time. Please choose one.")
}

addtask do_check_soar_features before do_build

# image size -> 512MB
IMAGE_ROOTFS_SIZE ?= "475136"

IMAGE_INSTALL += "\
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    caltool \
    sensord \
    variod \
    ovmenu-ng \
"

IMAGE_INSTALL:append = "${@bb.utils.contains('DISTRO_FEATURES', 'opensoar', ' opensoar', '', d)}"
IMAGE_INSTALL:append = "${@bb.utils.contains('DISTRO_FEATURES', 'xcsoar', ' xcsoar', '', d)}"

export IMAGE_BASENAME = "openvario-image"
export IMAGE_TYPE = ""
