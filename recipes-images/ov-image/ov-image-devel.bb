#Angstrom bootstrap image
require ov-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "
IMAGE_ROOTFS_SIZE = "8337408"

IMAGE_INSTALL += "\
	linux-firmware \
	devmem2 \
	memtester \
	sunxi-mali \
	jpeg \
	libpng \
	libc6-dev \
	libgcc-dev \
	libstdc++-dev \
	alsa-lib-dev \
	pkgconfig \	
	g++ \
	gcc \
	gdb \
	make \
	binutils \
	git \
	vim \
	gcc-symlinks \
	g++-symlinks \
	xcsoar-testing \
        xcsoar-profiles \
        xcsoar-menu \
        xcsoar-maps-default \
"

export IMAGE_BASENAME = "ov-image-devel"
