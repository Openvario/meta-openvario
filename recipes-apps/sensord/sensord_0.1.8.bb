# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Sensord Daemon for Openvario"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"
DEPENDS = ""
PR = "r1"

S = "${WORKDIR}/git"

inherit systemd

SRC_URI = "git://www.openvario.org/git-repos/sensord.git;protocol=http;tag=0.1.8;user=guest:Thahh3th \
			  file://sensord.service \	
"

do_compile() {
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git
	make sensord
}

do_install() {
	install -d ${D}/opt/bin
	install -m 0755 ${S}/sensord ${D}/opt/bin
	install -m 0755 ${S}/sensord.conf ${D}/opt/bin
	
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/sensord.service ${D}${systemd_unitdir}/system
}

PACKAGES = "${PN}"
FILES_${PN} = "/opt/bin/sensord \
					${systemd_unitdir}/system/sensord.service \
"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "sensord.service"
