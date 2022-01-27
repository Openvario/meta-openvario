# inherit extrausers

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://pulseaudio.service"

SYSTEMD_PACKAGES = "${PN}-server"
SYSTEMD_SERVICE:${PN}-server = "pulseaudio.service"
FILES:${PN}-server += " ${systemd_unitdir}/system/pulseaudio.service "

do_install:append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${B}/../pulseaudio.service ${D}${systemd_unitdir}/system
}
