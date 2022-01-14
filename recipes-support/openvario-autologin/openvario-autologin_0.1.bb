SUMMARY = "Autologin config for user openvario"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"

PR = "r1"

inherit allarch

SRC_URI = "file://autologin.conf"

do_install() {
	install -d ${D}${systemd_unitdir}/system/
	install -d ${D}${systemd_unitdir}/system/getty@tty1.service.d/
	install -m 0644 ${WORKDIR}/autologin.conf ${D}${systemd_unitdir}/system/getty@tty1.service.d/
}

RDEPENDS_${PN} = "systemd"

FILES_${PN} = "${systemd_unitdir}/system/getty@tty1.service.d/autologin.conf"

