DESCRIPTION = "OPKG feed for kedder PPA"
HOMEPAGE = "https://github.com/kedder/openvario-ppa"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit allarch

SRC_URI = " \
    file://kedder-feeds.conf \
"

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
    install -d ${D}/etc/opkg
    install -m 0644 ${WORKDIR}/kedder-feeds.conf ${D}/etc/opkg
}

FILES:${PN} = "/etc/opkg/kedder-feeds.conf"
