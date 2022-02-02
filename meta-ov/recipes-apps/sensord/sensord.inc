DESCRIPTION = "Sensord Daemon for Openvario"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"
DEPENDS = ""

INSANE_SKIP:${PN} += "ldflags"

S = "${WORKDIR}/git"

inherit systemd

SRC_URI += " \
	file://sensord.service \
"

do_compile() {
	oe_runmake
}

do_install() {
	install -d ${D}/opt/bin
	install -d ${D}/opt/conf
	install -m 0755 ${S}/sensord ${D}/opt/bin
	install -m 0755 ${S}/sensorcal ${D}/opt/bin
	install -m 0755 ${S}/sensord.conf ${D}/opt/conf/sensord.conf

	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sensord.service ${D}${systemd_unitdir}/system
}

PACKAGES = "${PN}"
INHIBIT_PACKAGE_DEBUG_SPLIT = '1'

FILES:${PN} = "\
        /opt/bin/sensord \
        /opt/bin/sensorcal \
        /opt/conf/sensord.conf \
        ${systemd_unitdir}/system/sensord.service \
"

CONFFILES:${PN} = " \
	/opt/conf/sensord.conf \
"

FILES:${PN}-dev = "/usr/src/debug/sensord-testing/git-r7/git/*"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "sensord.service"
