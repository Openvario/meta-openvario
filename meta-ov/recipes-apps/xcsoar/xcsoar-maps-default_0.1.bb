# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar Maps default"
HOMEPAGE = ""
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r2"

SRC_URI =      "\
	file://openvario_default.xcm \
"

addtask do_package_write_ipk after do_package

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}${ROOT_HOME}/.xcsoar
        install -m 0755 ${S}/*.xcm ${D}${ROOT_HOME}/.xcsoar/
}

FILES:${PN} = "${ROOT_HOME}/.xcsoar/*"

