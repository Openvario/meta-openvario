SUMMARY = "Creates configfile for autofs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r1"


SRC_URI = "file://auto.usb \
"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
	#install files in /etc	
	#nstall -d ${D}/etc
	install -m 0644 ${WORKDIR}/auto.usb ${D}/etc

}


FILES_${PN} += " \
		/etc/auto.usb \
				"

