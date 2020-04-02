# inherit extrausers

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://pulseaudio.service"

SYSTEMD_PACKAGES = "${PN}-server"
SYSTEMD_SERVICE_${PN}-server = "pulseaudio.service"
FILES_${PN}-server += " ${systemd_unitdir}/system/pulseaudio.service "

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${B}/../pulseaudio.service ${D}${systemd_unitdir}/system
}
