# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar Maps ALPS"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r3"

BB_STRICT_CHECKSUM = "0"

SRC_URI =	"\
	http://download.xcsoar.org/maps/ALPS_HighRes.xcm;name=alpsmap \
	http://www.austrocontrol.at/jart/prj3/austro_control/data/uploads/austria_ATS_2011_openair.txt;name=airspaceat \
"

SRC_URI[alpsmap.md5sum] = "1216ad8222dad27024f77e799ceb9b67"
SRC_URI[alpsmap.sha256sum] = "851ec5a90fb4b32b991b79293faaf087419c0d790c44aa202cb12a726fbf9c8f"

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

