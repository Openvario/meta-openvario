# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OpenVario live-to-persistent system settings sync"
HOMEPAGE = "www.openvario.org"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SECTION = "base/app"

S = "${WORKDIR}"
require ov-revision.inc

inherit systemd

SRC_URI = " \
	file://sync-display-config.sh \
	file://sync-display-config.service \
	file://sync-display-config.timer \
"

do_compile() {
	:
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/sync-display-config.sh ${D}${bindir}
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sync-display-config.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sync-display-config.timer ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE:${PN} = "sync-display-config.timer"

FILES:${PN} = " \
	${bindir}/sync-display-config.sh \
	${systemd_unitdir}/system/sync-display-config.service \
	${systemd_unitdir}/system/sync-display-config.timer \
"
