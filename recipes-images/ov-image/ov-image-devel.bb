#Angstrom bootstrap image
require console-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "
IMAGE_ROOTFS_SIZE = "8337408"

IMAGE_INSTALL += "\
	linux-firmware \
   	i2c-tools \
	devmem2 \
	sunxi-mali \
	jpeg \
	libpng \
	pkgconfig \	
	g++ \
	gcc \
	make \
	git \
	vim \
"

export IMAGE_BASENAME = "ov-image-devel"
