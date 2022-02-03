# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu Next-Generation"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r15"

inherit allarch systemd

RDEPENDS:${PN} = " \
	bash \
	dialog \
	ovmenu-ng-skripts \
	ov-tools \
"

# the "autologin" package is obsolete and interferes with this one
# the "autostart" package was merged into this one
RCONFLICTS:${PN} = " \
	openvario-autologin \
	ovmenu-ng-autostart \
"

SRC_URI =      "\
	file://ovmenu-ng.sh \
	file://openvario.rc \
	file://${PN}.service \
"


addtask do_package_write_ipk after do_package

do_compile() {
	:
}

do_install() {
	install -d ${D}/${bindir}
	install -m 0755 ${S}/ovmenu-ng.sh ${D}/${bindir}
	install -d ${D}${ROOT_HOME}
	install -m 0755 ${S}/openvario.rc ${D}${ROOT_HOME}/.dialogrc
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/ovmenu-ng.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE:${PN} = "${PN}.service"

FILES:${PN} = " \
	${bindir}/ovmenu-ng.sh \
	${ROOT_HOME}/.dialogrc \
"
