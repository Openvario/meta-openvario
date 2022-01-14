SUMMARY = "Autostart ovmenu-ng"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"

PR = "r2"

inherit allarch

SRC_URI = "file://.profile"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
        #install files in root home directory
        install -d ${D}${ROOT_HOME}
        install -m 0644 ${WORKDIR}/.profile ${D}${ROOT_HOME}/

}


FILES_${PN} += "${ROOT_HOME}/.profile \
"

RDEPENDS_${PN} = "bash ov-tools ovmenu-ng-skripts"
