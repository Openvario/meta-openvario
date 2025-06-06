# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Variod Daemon for Openvario"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}/git"

INSANE_SKIP:${PN} += "ldflags"

inherit systemd

DEPENDS = " \
	pulseaudio \
	libgcc \
	"

RDEPENDS:${PN} = " \
	pulseaudio-server \
"

SRC_URI = "file://variod.service \
           file://variod.cfgmgr "

do_compile() {
	cd ${WORKDIR}/git
	oe_runmake clean
	oe_runmake
}

do_install() {
	install -d ${D}/opt/bin
	install -d ${D}/opt/conf/default
	install -d ${D}/opt/conf
	install -m 0755 ${S}/variod ${D}/opt/bin
	install -m 0755 ${S}/variod.conf ${D}/opt/conf/default
	install -m 0755 ${S}/variod.conf ${D}/opt/conf
	
	install -d ${D}/etc/cfgmgr.d
	install -m 0755 ${WORKDIR}/variod.cfgmgr ${D}/etc/cfgmgr.d/variod.cfgmgr
	
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/variod.service ${D}${systemd_unitdir}/system
}

PACKAGES = "${PN}"
INHIBIT_PACKAGE_DEBUG_SPLIT = '1'
FILES:${PN} = "/opt/bin/variod \
					/opt/conf/default/variod.conf \
					/opt/conf/variod.conf \
					/etc/cfgmgr.d/variod.cfgmgr \
					${systemd_unitdir}/system/variod.service \
"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "variod.service"
