SUMMARY = "Configuration files for Openvario kernel modules"
DESCRIPTION = "Modules autoload configuration for all necessary kernel modules for Flightcomputer"
SECTION = "kernel/modules"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
PR = "r1"

SRC_URI = "file://openvario.conf \
"


do_compile() {
}

do_install() {
	install -d ${D}${sysconfdir}/modules-load.d

	install -m 0644 ${WORKDIR}/openvario.conf ${D}${sysconfdir}/modules-load.d/openvario.conf
}
