FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://wpa_supplicant@.service"

inherit systemd

do_install:append() {
    install -Dm0644 ${WORKDIR}/wpa_supplicant@.service ${D}${systemd_system_unitdir}/wpa_supplicant@.service
}

SYSTEMD_SERVICE:${PN} += "wpa_supplicant@wlan0.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"