# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar Maps ALPS"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r2"

BB_STRICT_CHECKSUM = "0"

SRC_URI =	"\
	http://download.xcsoar.org/maps/ALPS_HighRes.xcm;name=alpsmap \
	http://www.austrocontrol.at/jart/prj3/austro_control/data/uploads/austria_ATS_2011_openair.txt;name=airspaceat \
"


SRC_URI[alpsmap.md5sum] = "395f93909c1053e4c17bb8c90ff38fbe"
SRC_URI[alpsmap.sha256sum] = "1a50789146891565415fd0639d3d2ed0874c7b82c4aa5ab1252f982ff982f676"

addtask do_package_write_ipk after do_package after do_install

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/home/root/.xcsoar
        install -m 0755 ${S}/*.xcm ${D}/home/root/.xcsoar/
		  install -m 0755 ${S}/*.txt ${D}/home/root/.xcsoar/
}

FILES_${PN} = "/home/root/.xcsoar/*"

