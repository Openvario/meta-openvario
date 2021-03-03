# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Sensord Daemon for Openvario"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"
DEPENDS = ""
PR = "r9"

S = "${WORKDIR}/git"

inherit systemd
SRCREV_pn-sensord-testing = "${AUTOREV}"

SRC_URI = "git://github.com/Openvario/sensord.git;protocol=git;branch=master \
			file://sensord.service \
			file://sensord.cfgmgr \			  
"

INSANE_SKIP_${PN} = "ldflags"

SYSTEMD_SERVICE_${PN} = "sensord.service"

do_compile() {
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git
	make
}

do_install() {
	install -d ${D}/opt/bin
	install -d ${D}/opt/conf
	install -d ${D}/opt/conf/default
	install -d ${D}/etc/cfgmgr.d
	install -m 0755 ${S}/sensord ${D}/opt/bin
	install -m 0755 ${S}/compdata ${D}/opt/bin
	install -m 0755 ${S}/sensorcal ${D}/opt/bin
	install -m 0755 ${S}/sensord.conf ${D}/opt/conf/default/sensord.conf
	install -m 0755 ${S}/sensord.conf ${D}/opt/conf/sensord.conf
	install -m 0755 ${WORKDIR}/sensord.cfgmgr ${D}/etc/cfgmgr.d/sensord.cfgmgr
	
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sensord.service ${D}${systemd_unitdir}/system
}



PACKAGES = "${PN}"
INHIBIT_PACKAGE_DEBUG_SPLIT = '1'

FILES_${PN} = "/opt/bin/sensord \
					/opt/bin/compdata \
					/opt/bin/sensorcal \
					/opt/conf/default/sensord.conf \
					/etc/cfgmgr.d/sensord.cfgmgr \
					/opt/conf/sensord.conf \
"

CONFFILES_${PN} = " \
	/opt/conf/sensord.conf \
"

FILES_${PN}-dev = "/usr/src/debug/sensord-testing/git-r7/git/*"

SYSTEMD_SERVICE_${PN} = "sensord.service"
