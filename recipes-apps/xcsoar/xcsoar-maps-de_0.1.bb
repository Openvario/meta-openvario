# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar Maps DE"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r2"

SRC_URI =      "\
	http://download.xcsoar.org/maps/GER_HighRes.xcm;name=germanmap \
        http://www.daec.de/fileadmin/user_upload/files/2012/fachbereiche/luftraum/20140306OpenAir.txt;name=airspacede \
"


SRC_URI[germanmap.md5sum] = "1b3d0345c8970580fdab3778a2568ca7"
SRC_URI[germanmap.sha256sum] = "54f6320e999a9aadb1af453369ac7f9b608b37063d83c6b33c9bd870c2877fba"
SRC_URI[airspacede.md5sum] = "02096949c867fde7b7dce6c360e23c69"
SRC_URI[airspacede.sha256sum] = "bb636d4328576b8f5d1a794689f30e44059828f349c190e4e5209bc6ee307341"

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

