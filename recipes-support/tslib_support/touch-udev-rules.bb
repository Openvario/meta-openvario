SUMMARY = "udev rules for sunxi touch"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
PR = "r2"    

SRC_URI = "file://sunxi4-ts.rules"    

S = "${WORKDIR}"

inherit allarch

do_install () {
    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0666 ${WORKDIR}/sunxi4-ts.rules  ${D}${sysconfdir}/udev/rules.d/
}    

FILES:${PN} += " /etc/udev/rules.d/sunxi4-ts.rules"
