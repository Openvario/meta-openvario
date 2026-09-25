SUMMARY = "OpenVario persistent system-state preparation"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI = " \
	file://persistence-connman \
	file://persistence-touchscreen \
	file://persistence-sensord \
	file://persistence-variod \
	file://persistence-dropbear \
	file://ov-persistence@.service \
	file://connman-persistence.conf \
	file://ts-uinput-persistence.conf \
	file://ovmenu-persistence.conf \
	file://sensord-persistence.conf \
	file://variod-persistence.conf \
	file://dropbear-persistence.conf \
"

S = "${WORKDIR}"

inherit allarch

RDEPENDS:${PN} = "busybox udev ov-data-storage"

do_install() {
	install -d ${D}${libexecdir}/openvario
	for subsystem in connman touchscreen sensord variod dropbear; do
		install -m 0755 ${WORKDIR}/persistence-$subsystem \
			${D}${libexecdir}/openvario/persistence-$subsystem
	done
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/ov-persistence@.service \
		${D}${systemd_unitdir}/system
	install -d ${D}${systemd_unitdir}/system/connman.service.d
	install -m 0644 ${WORKDIR}/connman-persistence.conf \
		${D}${systemd_unitdir}/system/connman.service.d/10-openvario-persistence.conf
	install -d ${D}${systemd_unitdir}/system/ts_uinput.service.d
	install -m 0644 ${WORKDIR}/ts-uinput-persistence.conf \
		${D}${systemd_unitdir}/system/ts_uinput.service.d/10-openvario-persistence.conf
	install -d ${D}${systemd_unitdir}/system/ovmenu-ng.service.d
	install -m 0644 ${WORKDIR}/ovmenu-persistence.conf \
		${D}${systemd_unitdir}/system/ovmenu-ng.service.d/10-openvario-persistence.conf
	install -d ${D}${systemd_unitdir}/system/sensord.service.d
	install -m 0644 ${WORKDIR}/sensord-persistence.conf \
		${D}${systemd_unitdir}/system/sensord.service.d/10-openvario-persistence.conf
	install -d ${D}${systemd_unitdir}/system/variod.service.d
	install -m 0644 ${WORKDIR}/variod-persistence.conf \
		${D}${systemd_unitdir}/system/variod.service.d/10-openvario-persistence.conf
	install -d ${D}${systemd_unitdir}/system/dropbearkey.service.d
	install -m 0644 ${WORKDIR}/dropbear-persistence.conf \
		${D}${systemd_unitdir}/system/dropbearkey.service.d/10-openvario-persistence.conf
}

FILES:${PN} = " \
	${libexecdir}/openvario/persistence-connman \
	${libexecdir}/openvario/persistence-touchscreen \
	${libexecdir}/openvario/persistence-sensord \
	${libexecdir}/openvario/persistence-variod \
	${libexecdir}/openvario/persistence-dropbear \
	${systemd_unitdir}/system/ov-persistence@.service \
	${systemd_unitdir}/system/connman.service.d/10-openvario-persistence.conf \
	${systemd_unitdir}/system/ts_uinput.service.d/10-openvario-persistence.conf \
	${systemd_unitdir}/system/ovmenu-ng.service.d/10-openvario-persistence.conf \
	${systemd_unitdir}/system/sensord.service.d/10-openvario-persistence.conf \
	${systemd_unitdir}/system/variod.service.d/10-openvario-persistence.conf \
	${systemd_unitdir}/system/dropbearkey.service.d/10-openvario-persistence.conf \
"
