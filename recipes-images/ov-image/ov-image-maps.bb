#Angstrom bootstrap image
require console-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "

IMAGE_ROOTFS_SIZE = "3768320"

IMAGE_INSTALL += " \
	xcsoar-maps-de \
	xcsoar-maps-alps \
	xcsoar-maps-flarmnet \
"

export IMAGE_BASENAME = "ov-image-maps"
