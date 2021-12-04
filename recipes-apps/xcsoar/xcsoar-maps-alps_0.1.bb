# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar Maps ALPS"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r4"

BB_STRICT_CHECKSUM = "0"

SRC_URI =	"\
	http://download.xcsoar.org/maps/ALPS_HighRes.xcm;name=alpsmap \
	http://www.austrocontrol.at/jart/prj3/austro_control/data/uploads/austria_ATS_2011_openair.txt;name=airspaceat \
"

SRC_URI[alpsmap.md5sum] = "3135fe5e632a5e0c0e084652be8b14b6"
SRC_URI[alpsmap.sha256sum] = "90987f93f6ee4f1c4c89a827c21782b06abba8b644534fa8161e283d17ba99ac"
SRC_URI[airspaceat.md5sum] = "8963def8118f0b92da5f0cac862e6cf3"
SRC_URI[airspaceat.sha256sum] = "f5e79df3e89cc982b47e3e0e1c9c59b419556d1747878a830040f0e083f00bc2"

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

