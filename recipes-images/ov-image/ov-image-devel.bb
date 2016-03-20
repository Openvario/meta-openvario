#Angstrom bootstrap image
require ov-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "
IMAGE_ROOTFS_SIZE = "8337408"

IMAGE_INSTALL += "\
	linux-firmware \
	packagegroup-ov-devel-tools \
"

export IMAGE_BASENAME = "ov-image-devel"
