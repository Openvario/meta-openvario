#Openvario release image

require ov-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "

IMAGE_ROOTFS_SIZE = "3768320"

#IMAGE_FEATURES += "debug-tweaks"

IMAGE_INSTALL += "\
	xcsoar-profiles \
	xcsoar-menu \
	xcsoar-maps-default \
	variod \
	sensord \
	libsdl \
	jpeg \
	freetype \
	libpng \
	libinput \
	boost \
	sunxi-mali \
	lua \
	udev \
	"

export IMAGE_BASENAME = "ov-image-bla"
