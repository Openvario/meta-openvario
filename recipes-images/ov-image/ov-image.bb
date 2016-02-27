#Angstrom bootstrap image
#require console-base-image.bb
require ov-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "

IMAGE_ROOTFS_SIZE = "3768320"

IMAGE_FEATURES += "debug-tweaks"

IMAGE_INSTALL += "\
    xcsoar \
	xcsoar-profiles \
	xcsoar-menu \
	xcsoar-maps-default \
	variod \
	"

export IMAGE_BASENAME = "ov-image"
