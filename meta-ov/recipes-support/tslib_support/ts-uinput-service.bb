# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Systemd service for ts_uinput"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"
DEPENDS = "tslib"
PR = "r2"

S = "${WORKDIR}"

inherit allarch systemd

SRC_URI = "	file://ts_uinput.service \
			file://ts.env \
"

do_install() {	
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/ts_uinput.service ${D}${systemd_unitdir}/system

	install -d ${D}${sysconfdir}
	install -m 0666 ${WORKDIR}/ts.env  ${D}${sysconfdir}	
}


SYSTEMD_SERVICE:${PN} = "ts_uinput.service"
