# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OpenVario live-to-persistent system settings sync"
HOMEPAGE = "www.openvario.org"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SECTION = "base/app"

S = "${WORKDIR}"
require ov-revision.inc

inherit systemd

RDEPENDS:${PN} = "busybox ov-data-storage"

SRC_URI = " \
	file://settings-common.sh \
	file://boot-config.sh \
	file://restore-display-config.sh \
	file://main-app-config.sh \
	file://service-policy.sh \
	file://sync-display-config.sh \
	file://sync-display-config.service \
	file://sync-display-config.timer \
	file://save-display-config.service \
	file://restore-service-policy.service \
	file://dropbear-policy.conf \
	file://sync-service-policy.service \
	file://sync-service-policy.path \
"

do_compile() {
	:
}

do_install() {
	install -d ${D}${libexecdir}/openvario
	install -m 0644 ${S}/settings-common.sh \
		${D}${libexecdir}/openvario/settings-common.sh
	install -m 0755 ${S}/boot-config.sh \
		${D}${libexecdir}/openvario/boot-config
	install -d ${D}${bindir}
	install -m 0755 ${S}/restore-display-config.sh ${D}${bindir}
	install -m 0755 ${S}/main-app-config.sh ${D}${bindir}
	install -m 0755 ${S}/service-policy.sh ${D}${bindir}
	install -m 0755 ${S}/sync-display-config.sh ${D}${bindir}
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sync-display-config.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sync-display-config.timer ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/save-display-config.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/restore-service-policy.service ${D}${systemd_unitdir}/system
	install -d ${D}${systemd_unitdir}/system/dropbear.socket.d
	install -m 0644 ${WORKDIR}/dropbear-policy.conf \
		${D}${systemd_unitdir}/system/dropbear.socket.d/10-openvario-policy.conf
	install -m 0644 ${WORKDIR}/sync-service-policy.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sync-service-policy.path ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE:${PN} = "sync-display-config.timer save-display-config.service restore-service-policy.service sync-service-policy.path"

FILES:${PN} = " \
	${libexecdir}/openvario/settings-common.sh \
	${libexecdir}/openvario/boot-config \
	${bindir}/restore-display-config.sh \
	${bindir}/main-app-config.sh \
	${bindir}/service-policy.sh \
	${bindir}/sync-display-config.sh \
	${systemd_unitdir}/system/sync-display-config.service \
	${systemd_unitdir}/system/sync-display-config.timer \
	${systemd_unitdir}/system/save-display-config.service \
	${systemd_unitdir}/system/restore-service-policy.service \
	${systemd_unitdir}/system/dropbear.socket.d/10-openvario-policy.conf \
	${systemd_unitdir}/system/sync-service-policy.service \
	${systemd_unitdir}/system/sync-service-policy.path \
"
