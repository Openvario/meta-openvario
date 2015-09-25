# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu Next-Generation"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r5"

RDEPENDS_${PN} = "bash dialog-static"

SRC_URI =      "\
	file://ovmenu-ng.sh \
"


addtask do_package_write_ipk after do_package after do_install

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/opt/bin
        install -m 0755 ${S}/ovmenu-ng.sh ${D}/opt/bin/ovmenu-ng.sh
}

FILES_${PN} = "/opt/bin/ovmenu-ng.sh \
"
