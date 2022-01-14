# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu Next-Generation"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r15"

RDEPENDS_${PN} = " \
	bash \
	dialog \
	ovmenu-ng-skripts \
        ovmenu-ng-autostart \
"

SRC_URI =      "\
	file://ovmenu-ng.sh \
	file://openvario.rc \
"


addtask do_package_write_ipk after do_package

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/opt/bin
        install -m 0755 ${S}/ovmenu-ng.sh ${D}/opt/bin/ovmenu-ng.sh
	install -d ${D}${ROOT_HOME}
	install -m 0755 ${S}/openvario.rc ${D}${ROOT_HOME}/.dialogrc
}

FILES_${PN} = "/opt/bin/ovmenu-ng.sh \
	${ROOT_HOME}/.dialogrc \
"
