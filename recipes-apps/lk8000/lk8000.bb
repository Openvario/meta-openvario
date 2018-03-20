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
PR = "r9"

SRC_URI = "git://github.com/brunotl/LK8000.git;protocol=https;branch=OpenVario;tag=OpenVario"
SRC_REV = "0463e25b29085c8296c95fc5b6bf1bd81dee2fcc"


addtask do_package_write_ipk after do_package after do_install

do_compile() {
	echo "Making .."
	cd ${WORKDIR}/git
	make -j8 TARGET=OPENVARIO
}

do_install() {
	echo "Installing ..."
	cd ${WORKDIR}/git
	install -d ${D}/opt
	make install TARGET=OPENVARIO INSTALL_PATH=${D}/opt
	
	install -d ${D}/opt/LK8000/bin
	mv ${D}/opt/LK8000/LK8000-OPENVARIO ${D}/opt/LK8000/bin/LK8000-OPENVARIO

	install -d ${D}/opt/LK8000/share
	mv ${D}/opt/LK8000/_System ${D}/opt/LK8000/share/_System
	mv ${D}/opt/LK8000/_Language ${D}/opt/LK8000/share/_Language
	mv ${D}/opt/LK8000/_Polars ${D}/opt/LK8000/share/_Polars

	install -d ${D}/home/root/LK8000
	
	install -d ${D}/home/root/LK8000/_Polars
	mv ${D}/opt/LK8000/share/_Polars/Example.plr ${D}/home/root/LK8000/_Polars/Example.plr

	mv ${D}/opt/LK8000/_Waypoints ${D}/home/root/LK8000/_Waypoints
	mv ${D}/opt/LK8000/_Tasks ${D}/home/root/LK8000/_Tasks
	mv ${D}/opt/LK8000/_Logger  ${D}/home/root/LK8000/_Logger
	mv ${D}/opt/LK8000/_Maps  ${D}/home/root/LK8000/_Maps
	mv ${D}/opt/LK8000/_Airspaces  ${D}/home/root/LK8000/_Airspaces
	mv ${D}/opt/LK8000/_Configuration  ${D}/home/root/LK8000/_Configuration

}

FILES_${PN} = " \
	/opt/LK8000/bin/LK8000-OPENVARIO \
	/opt/LK8000/share/_System/* \
	/opt/LK8000/share/_System/_Bitmaps/* \
	/opt/LK8000/share/_System/_Sounds/* \
	/opt/LK8000/share/_Language/* \
	/opt/LK8000/share/_Polars/* \
	/home/root/LK8000/_Polars/* \
	/home/root/LK8000/_Waypoints/* \
	/home/root/LK8000/_Tasks \
	/home/root/LK8000/_Logger \
	/home/root/LK8000/_Maps \
	/home/root/LK8000/_Airspaces \
	/home/root/LK8000/_Configuration/* \
"

