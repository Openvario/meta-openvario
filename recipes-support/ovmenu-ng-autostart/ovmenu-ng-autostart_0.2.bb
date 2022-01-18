SUMMARY = "Autostart ovmenu-ng"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"

PR = "r1"

inherit allarch systemd

SRC_URI = " \
	file://ovmenu-ng.service \
"

# the "autologin" package is obsolete and interferes with this one
RCONFLICTS_${PN} = "openvario-autologin"

SYSTEMD_SERVICE_${PN} = "ovmenu-ng.service"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/ovmenu-ng.service ${D}${systemd_unitdir}/system
}

RDEPENDS_${PN} = "bash ov-tools ovmenu-ng-skripts"
