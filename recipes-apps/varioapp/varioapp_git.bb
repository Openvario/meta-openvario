# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Varioapp Daemon for Openvario"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"
DEPENDS = ""
PR = "r3"

S = "${WORKDIR}/git"

SRCREV_pn-varioapp = "${AUTOREV}" 

inherit systemd

SRC_URI = "git://git-ro.openvario.org/varioapp.git;protocol=http \
			  file://varioapp.service \	
"

do_compile() {
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git
	make
}

do_install() {
	install -d ${D}/opt/bin
	install -m 0755 ${S}/varioapp ${D}/opt/bin
	install -m 0755 ${S}/varioapp.conf ${D}/opt/bin
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/varioapp.service ${D}${systemd_unitdir}/system
}

PACKAGES = "${PN}"
FILES_${PN} = "/opt/bin/varioapp \
					/opt/bin/varioapp.conf \
					${systemd_unitdir}/system/varioapp.service \
"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "varioapp.service"
