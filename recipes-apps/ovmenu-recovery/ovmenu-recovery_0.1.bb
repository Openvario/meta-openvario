# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OpenVario recovery menu"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"
DEPENDS = "dialog"
RDEPENDS_${PN} = "dialog \
					bash \
				"
PR = "r6"

S = "${WORKDIR}"

SRC_URI = " \
	file://ovmenu-recovery.sh \
	file://openvario.rc \	
"

do_compile() {
}

do_install() {
	install -d ${D}/opt/bin
	install -m 0755 ${S}/ovmenu-recovery.sh ${D}/opt/bin
	install -m 0755 ${S}/openvario.rc ${D}/opt/bin
	
}

PACKAGES = "${PN}"
FILES_${PN} = " \
	/opt/bin/ovmenu-recovery.sh \
	/opt/bin/openvario.rc \
"
