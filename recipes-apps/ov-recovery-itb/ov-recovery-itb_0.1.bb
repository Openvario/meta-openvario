# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Packaged recovery ITB for Cubieboard-based OpenVarios"
HOMEPAGE = "www.openvario.org"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SECTION = "base/app"

S = "${WORKDIR}"
require ov-revision.inc

COMPATIBLE_MACHINE = "cubieboard2"

do_install[depends] += "openvario-recovery-image:do_deploy"

do_compile() {
	:
}

do_install() {
	install -d ${D}${bindir}
	install -m 0644 ${DEPLOY_DIR_IMAGE}/ov-recovery.itb ${D}${bindir}/ov-recovery.itb
}

FILES:${PN} = " \
	${bindir}/ov-recovery.itb \
"