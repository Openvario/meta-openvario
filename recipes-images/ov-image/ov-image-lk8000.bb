#Angstrom bootstrap image
#require console-base-image.bb
require ov-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "

IMAGE_ROOTFS_SIZE = "3768320"

IMAGE_FEATURES += "debug-tweaks"

IMAGE_INSTALL += "\
        lk8000 \
	variod \
	sensord \
	"

export IMAGE_BASENAME = "ov-image"
