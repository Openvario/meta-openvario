# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar Maps FLARMNET Database"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r4"


SRC_URI =      " \
	http://www.flarmnet.org/files/data.fln;name=flarmnet \
"


SRC_URI[flarmnet.md5sum] = "249add771eb0a6f7a7f7c32f1d917335"
SRC_URI[flarmnet.sha256sum] = "7cc96e06bc417c42d2437e470524cde2e00b41da58dc354a426bede1738c3d04"

addtask do_package_write_ipk after do_package after do_install

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/home/root/.xcsoar
        install -m 0755 ${S}/data.fln ${D}/home/root/.xcsoar/
}

FILES_${PN} = "/home/root/.xcsoar/*"

