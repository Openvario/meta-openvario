SUMMARY = "OpenVario system tools presented by XCSoar"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
	file://sensor-calibration \
	file://sensor-calibration.tool \
	file://sensor-initialization \
	file://sensor-initialization.tool \
	file://system-information \
	file://system-information.tool \
	file://touchscreen-calibration \
	file://touchscreen-calibration.tool \
"

S = "${WORKDIR}"

inherit allarch

RDEPENDS:${PN} = "ov-system-tools"

do_install() {
	install -d ${D}${libexecdir}/xcsoar/system-tools
	for tool in sensor-calibration sensor-initialization system-information touchscreen-calibration; do
		install -m 0755 ${WORKDIR}/$tool \
			${D}${libexecdir}/xcsoar/system-tools/$tool
		install -m 0644 ${WORKDIR}/$tool.tool \
			${D}${libexecdir}/xcsoar/system-tools/$tool.tool
	done
}

FILES:${PN} = "${libexecdir}/xcsoar/system-tools"
