SUMMARY = "Automatically mount connected USB drives"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r1"

inherit allarch systemd

SRC_URI = "\
	file://usb.mount \
	file://usb.automount \
"

SYSTEMD_SERVICE:${PN} = "usb.mount usb.automount"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/usb.mount ${WORKDIR}/usb.automount ${D}${systemd_unitdir}/system
}
