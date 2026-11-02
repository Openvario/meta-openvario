SUMMARY = "Editable personal XCSoar tool examples"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
	file://cpu-log.sh \
	file://cpu-log.tool \
"

S = "${WORKDIR}"

inherit allarch

RDEPENDS:${PN} = "busybox systemd systemd-extra-utils"

do_install() {
	# The launcher seeds these defaults without replacing user files.
	install -d -m 0755 ${D}${ROOT_HOME}/.xcsoar/tools
	install -m 0755 ${WORKDIR}/cpu-log.sh ${D}${ROOT_HOME}/.xcsoar/tools/
	install -m 0644 ${WORKDIR}/cpu-log.tool ${D}${ROOT_HOME}/.xcsoar/tools/
}

FILES:${PN} = "${ROOT_HOME}/.xcsoar/tools"
