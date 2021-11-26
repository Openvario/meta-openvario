# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar Maps ALPS"
HOMEPAGE = ""
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r5"

BB_STRICT_CHECKSUM = "0"

SRC_URI =	"\
	http://download.xcsoar.org/maps/ALPS_HighRes.xcm;name=alpsmap \
	http://www.austrocontrol.at/jart/prj3/austro_control/data/uploads/austria_ATS_2011_openair.txt;name=airspaceat \
"

# Last change on 2021-11-22: md5=4d12760efda52fd96ab6386eca040ca2 
SRC_URI[alpsmap.md5sum] = "4d12760efda52fd96ab6386eca040ca2"
SRC_URI[alpsmap.sha256sum] = "2bee6fbb407668e38c46fb33878b857e7b140b385947536ea7dd0e1d442e7bdb"

# Last change on 2011(!): md5=8963def8118f0b92da5f0cac862e6cf3 
SRC_URI[airspaceat.md5sum] = "8963def8118f0b92da5f0cac862e6cf3"
SRC_URI[airspaceat.sha256sum] = "f5e79df3e89cc982b47e3e0e1c9c59b419556d1747878a830040f0e083f00bc2"

addtask do_package_write_ipk after do_package

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

