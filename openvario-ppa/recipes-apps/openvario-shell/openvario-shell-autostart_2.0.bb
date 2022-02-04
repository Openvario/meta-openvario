SUMMARY = "Autostart openvario-shell"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"

inherit allarch systemd

SRC_URI = " \
    file://ovshell.service \
"

RCONFLICTS:${PN} = "ovmenu-ng-autostart"

SYSTEMD_SERVICE:${PN} = "ovshell.service"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/ovshell.service ${D}${systemd_unitdir}/system
}

RDEPENDS:${PN} = "bash ov-tools ovmenu-ng-skripts"
