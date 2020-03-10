SUMMARY = "Automatically mount connected USB drives"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r4"

RDEPENDS_autofs-config = "autofs"

SRC_URI = "\
	file://auto.usb \
	file://usb.autofs \	
"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
	#install files in /etc	
	install -d ${D}/etc/auto.master.d
	install -m 0644 ${WORKDIR}/usb.autofs ${D}/etc/auto.master.d/usb.autofs
	install -m 0644 ${WORKDIR}/auto.usb ${D}/etc/auto.master.d/auto.usb

}


FILES_${PN} += " \
		/etc/auto.master.d/auto.usb \
		/etc/auto.master.d/usb.autofs \
"

