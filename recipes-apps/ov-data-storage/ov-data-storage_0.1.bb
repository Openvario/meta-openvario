SUMMARY = "OpenVario data partition preparation"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0-only;md5=c79ff39f19dfec6d293b95dea7b07891"

S = "${WORKDIR}"
require ov-revision.inc

inherit allarch systemd

PACKAGES =+ "${PN}-paths"
FILES:${PN}-paths = "${libexecdir}/openvario/paths.sh"

RDEPENDS:${PN} = " \
	bash \
	${PN}-paths \
	busybox \
	e2fsprogs-mke2fs \
	e2fsprogs-resize2fs \
	util-linux-partx \
	udev \
"

SRC_URI = " \
	file://paths.sh \
	file://ov-data-storage.sh \
	file://ov-data-storage.service \
	file://create_datapart.sh \
"

do_install() {
	install -d ${D}${libexecdir}/openvario
	install -m 0644 ${WORKDIR}/paths.sh ${D}${libexecdir}/openvario/paths.sh
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/ov-data-storage.sh ${D}${bindir}
	install -m 0755 ${WORKDIR}/create_datapart.sh ${D}${bindir}
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/ov-data-storage.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE:${PN} = "ov-data-storage.service"

FILES:${PN} = " \
	${bindir}/ov-data-storage.sh \
	${bindir}/create_datapart.sh \
	${systemd_unitdir}/system/ov-data-storage.service \
"
