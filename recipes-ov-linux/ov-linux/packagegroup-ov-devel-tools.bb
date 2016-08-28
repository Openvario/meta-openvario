DESCRIPTION = "Openvario development package group"

LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"

#PV = "${DISTRO_VERSION}"
PR = "r1"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

#PREFERRED_PROVIDER_jpeg = "libjpeg"
#PREFERRED_PROVIDER_jpeg-dev = "libjpeg"


RDEPENDS_${PN} = "\	
    	i2c-tools \
    	devmem2 \
	memtester \
	jpeg \
	libpng \
	libpng-dev \
	libc6-dev \
	libgcc-dev \
	gcc-dev \
	libstdc++-dev \
	sunxi-mali-dev \
	perl-module-data-dumper \
	perl-module-bytes \
	perl-module-lib \
	perl-module-file-basename \
	boost \
	boost-dev \
	pkgconfig \
	imagemagick \
	libxslt-bin \
	librsvg \
	rsvg \
	gettext \
    	g++ \
	gcc \
	gdb \
	make \
    	git \
	binutils \
	vim \
	gcc-symlinks \
	g++-symlinks \
	binutils \
	alsa-lib-dev \
	alsa-lib \
	"
