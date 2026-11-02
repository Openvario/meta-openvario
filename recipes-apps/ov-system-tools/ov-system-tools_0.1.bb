SUMMARY = "Reusable OpenVario system maintenance tools"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
	file://sensor-calibration \
	file://system-info \
	file://touchscreen-calibration \
"

S = "${WORKDIR}"

inherit allarch

RDEPENDS:${PN} = " \
	busybox \
	opkg \
	systemd \
	systemd-extra-utils \
	ts-uinput-service \
	tslib-calibrate \
	udev \
"

do_install() {
	install -d ${D}${libexecdir}/openvario
	for tool in sensor-calibration system-info touchscreen-calibration; do
		install -m 0755 ${WORKDIR}/$tool \
			${D}${libexecdir}/openvario/$tool
	done
}

FILES:${PN} = "${libexecdir}/openvario"
