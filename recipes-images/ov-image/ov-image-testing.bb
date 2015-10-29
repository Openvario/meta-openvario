#Angstrom bootstrap image
#require console-base-image.bb
require ov-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "

IMAGE_ROOTFS_SIZE = "3768320"

IMAGE_FEATURES += "debug-tweaks"

IMAGE_INSTALL += "\
	xcsoar-testing \
	xcsoar-profiles \
	xcsoar-menu \
	"

export IMAGE_BASENAME = "ov-image-testing"
