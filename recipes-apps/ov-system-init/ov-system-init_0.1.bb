# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OpenVario System Initialization"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
require ov-revision.inc

inherit systemd

RDEPENDS:${PN} = " \
	bash \
	ov-data-storage \
	ovmenu-ng-skripts \
	ov-persistence \
	ov-system-settings-sync \
"

SRC_URI = " \
	file://ov-system-init.sh \
	file://ov-system-init.service \
"

do_compile() {
	:
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/ov-system-init.sh ${D}${bindir}
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/ov-system-init.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE:${PN} = "ov-system-init.service"

FILES:${PN} = " \
	${bindir}/ov-system-init.sh \
	${systemd_unitdir}/system/ov-system-init.service \
"
