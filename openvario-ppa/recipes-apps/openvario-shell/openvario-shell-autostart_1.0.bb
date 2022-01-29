SUMMARY = "Autostart openvario-shell"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"

PR = "r5"

SRC_URI = "file://.profile"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
        #install files in root home directory
        install -d ${D}/home/root
        install -m 0644 ${WORKDIR}/.profile ${D}/home/root/

}


FILES_${PN} = "/home/root/.profile"
RDEPENDS_${PN} = "bash"
RCONFLICTS_${PN}="ovmenu-ng-autostart"
