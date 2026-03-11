require openvario-base-image.bb

# image size -> 512MB
IMAGE_ROOTFS_SIZE ?= "475136"

XCSOAR_LOCALE_PACKAGES = " \
    xcsoar-locale-de \
    xcsoar-locale-es \
    xcsoar-locale-fr \
    xcsoar-locale-it \
    xcsoar-locale-hu \
    xcsoar-locale-pl \
    xcsoar-locale-cs \
    xcsoar-locale-sk \
    xcsoar-locale-ru \
    xcsoar-locale-lt \
"

IMAGE_INSTALL += "\
    opensoar-testing \
    xcsoar-testing \
    xcsoar-menu \
    xcsoar-profiles \
    xcsoar-maps-default \
    caltool \
    sensord \
    variod \
    ovmenu-ng \
    ${XCSOAR_LOCALE_PACKAGES} \
"

export IMAGE_BASENAME = "openvario-testing"

#    sensord-testing 
#    variod-testing 
