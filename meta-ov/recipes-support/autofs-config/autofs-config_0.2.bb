SUMMARY = "Automatically mount connected USB drives"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r1"

inherit allarch systemd

SRC_URI = "\
	file://dev-sda1.device \
	file://boot.mount \
	file://boot.automount \
	file://usb-usbstick.mount \
	file://usb-usbstick.automount \
"

SYSTEMD_SERVICE:${PN} = " \
	boot.mount \
	boot.automount \
	usb-usbstick.mount \
	usb-usbstick.automount \
"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 \
		${WORKDIR}/dev-sda1.device \
		${WORKDIR}/boot.mount \
		${WORKDIR}/boot.automount \
		${WORKDIR}/usb-usbstick.mount \
		${WORKDIR}/usb-usbstick.automount \
		${D}${systemd_unitdir}/system
}

FILES:${PN} += " \
	${systemd_unitdir}/system/dev-sda1.device \
"
