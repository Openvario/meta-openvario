SUMMARY = "OpenVario Wi-Fi interface naming policy"
DESCRIPTION = "Keep kernel Wi-Fi interface names to avoid hotplug rename races"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://10-openvario-wifi.link"

S = "${WORKDIR}"

inherit allarch

RDEPENDS:${PN} = "udev"

do_install() {
	install -d ${D}${systemd_unitdir}/network
	install -m 0644 ${WORKDIR}/10-openvario-wifi.link \
		${D}${systemd_unitdir}/network/10-openvario-wifi.link
}

FILES:${PN} = "${systemd_unitdir}/network/10-openvario-wifi.link"
