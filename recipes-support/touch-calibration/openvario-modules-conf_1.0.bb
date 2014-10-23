SUMMARY = "Touch calibration for 4,3 inch Touch Screen"
DESCRIPTION = "Modules configuration for Touch"
SECTION = "kernel/modules"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
PR = "r1"

SRC_URI = "file://touch.conf \
"


do_compile() {
}

do_install() {
	install -d ${D}${sysconfdir}/modprobe.d

	install -m 0644 ${WORKDIR}/touch.conf ${D}${sysconfdir}/modprobe.d/touch.conf
}

FILES_${PN} = "${sysconfdir}/modprobe.d/*"
