#Angstrom bootstrap image
require ov-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "
IMAGE_ROOTFS_SIZE = "8337408"

IMAGE_INSTALL += "\
	linux-firmware \
	devmem2 \
	sunxi-mali \
	jpeg \
	libpng \
	pkgconfig \	
	g++ \
	gcc \
	gdb \
	make \
	git \
	vim \
	gcc-symlinks \
"

export IMAGE_BASENAME = "ov-image-devel"
