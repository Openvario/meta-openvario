SUMMARY = "OpenVario persistent system-state preparation"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI = " \
	file://persistence-connman \
	file://ov-persistence@.service \
	file://connman-persistence.conf \
"

S = "${WORKDIR}"

inherit allarch

RDEPENDS:${PN} = "busybox udev ov-data-storage"

do_install() {
	install -d ${D}${libexecdir}/openvario
	install -m 0755 ${WORKDIR}/persistence-connman \
		${D}${libexecdir}/openvario/persistence-connman
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/ov-persistence@.service \
		${D}${systemd_unitdir}/system
	install -d ${D}${systemd_unitdir}/system/connman.service.d
	install -m 0644 ${WORKDIR}/connman-persistence.conf \
		${D}${systemd_unitdir}/system/connman.service.d/10-openvario-persistence.conf
}

FILES:${PN} = " \
	${libexecdir}/openvario/persistence-connman \
	${systemd_unitdir}/system/ov-persistence@.service \
	${systemd_unitdir}/system/connman.service.d/10-openvario-persistence.conf \
"
