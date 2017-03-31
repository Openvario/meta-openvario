# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "LK8000 Tactical Flight Computer"
HOMEPAGE = "lk8000.it"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=801f80980d171dd6425610833a22dbe6"
SECTION = "base/app"
DEPENDS = "	freetype \
		libpng \
		libinput \
		zziplib \
		zlib \
		boost \
		ttf-dejavu \
		sunxi-mali \
		geographiclib \
		alsa-lib \
		libsndfile1 \
"



RDEPENDS_${PN} = "	sunxi-mali \
		  	libinput \
			freetype \
			libpng \
			udev \
			zziplib \
			zlib \
			geographiclib \
"

S = "${WORKDIR}/git"
PR = "r2"

SRC_URI = 	"git://github.com/brunotl/LK8000.git;protocol=http;branch=OpenVario;tag=OpenVario"



addtask do_package_write_ipk after do_package after do_install

do_compile() {
	echo "Making .."
	cd ${WORKDIR}/git
	make -j8 TARGET=OPENVARIO
}

do_install() {
	echo "Installing ..."
	cd ${WORKDIR}/git
	install -d ${D}/LK8000
	make install TARGET=OPENVARIO INSTALL_PATH=${D}
}

FILES_${PN} = " \
	/LK8000/LK8000-OPENVARIO \
	/LK8000/_System/* \
	/LK8000/_System/_Bitmaps/* \
	/LK8000/_System/_Sounds/* \
	/LK8000/_Polars/* \
	/LK8000/_Waypoints/* \
	/LK8000/_Tasks \
	/LK8000/_Language/* \
	/LK8000/_Logger \
	/LK8000/_Maps \
	/LK8000/_Airspaces \
	/LK8000/_Configuration/* \
"

