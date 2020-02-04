# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Variod Daemon for Openvario"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

DEPENDS = "\
	alsa-lib \
"

PR = "r10"

S = "${WORKDIR}/git"

SRCREV_pn-variod-testing = "${AUTOREV}" 

INSANE_SKIP_${PN} = "ldflags"
INSANE_SKIP_${PN}-dev = "ldflags"

inherit systemd

SRC_URI = "git://github.com/Openvario/variod.git;protocol=git \
			  file://variod.service \
			  file://variod.cfgmgr \
"

do_compile() {
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git
	make clean
	make
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
FILES_${PN} = "/opt/bin/variod \
					/opt/conf/default/variod.conf \
					/opt/conf/variod.conf \
					/etc/cfgmgr.d/variod.cfgmgr \
"

SYSTEMD_SERVICE_${PN} = "variod.service"
