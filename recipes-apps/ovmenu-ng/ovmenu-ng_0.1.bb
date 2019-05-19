# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu Next-Generation"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r14"

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


addtask do_package_write_ipk after do_package after do_install

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/opt/bin
        install -m 0755 ${S}/ovmenu-ng.sh ${D}/opt/bin/ovmenu-ng.sh
		install -d ${D}/home/root
		install -m 0755 ${S}/openvario.rc ${D}/home/root/.dialogrc
}

FILES_${PN} = "/opt/bin/ovmenu-ng.sh \
				/home/root/.dialogrc \
"
