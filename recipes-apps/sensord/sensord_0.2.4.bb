# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Sensord Daemon for Openvario"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"
DEPENDS = ""
PR = "r3"

S = "${WORKDIR}/git"

inherit systemd
SRCREV_pn-sensord = "${AUTOREV}"

SRC_URI = "git://git-ro.openvario.org/sensord.git;protocol=http \
			  file://sensord.service \	
"

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
	install -m 0755 ${S}/sensord ${D}/opt/bin
	install -m 0755 ${S}/sensorcal ${D}/opt/bin
	install -m 0755 ${S}/sensord.conf ${D}/opt/conf/default/sensord.conf
	install -m 0755 ${S}/sensord.conf ${D}/opt/conf/sensord.conf
	
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sensord.service ${D}${systemd_unitdir}/system
}

PACKAGES = "${PN}"
FILES_${PN} = "/opt/bin/sensord \
					/opt/bin/sensorcal \
					/opt/bin/conf/sensord.conf \
					/opt/bin/conf/default/sensord.conf \
					${systemd_unitdir}/system/sensord.service \
"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "sensord.service"
