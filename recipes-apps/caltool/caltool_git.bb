# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OpenVario Touch calibration tool"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"
PR = "r3"

DEPENDS = " \
				libinput \
"

INSANE_SKIP_${PN} = "ldflags"

S = "${WORKDIR}/git"

SRC_URI = "git://git-ro.openvario.org/ovmenu.git;protocol=http;rev=master\
"

do_compile() {
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git/caltool
	make
}

do_install() {
	install -d ${D}/opt/bin
	install -d ${D}/opt/conf
	install -m 0755 ${S}/caltool/caltool ${D}/opt/bin
}

PACKAGES = "${PN}"
INHIBIT_PACKAGE_DEBUG_SPLIT = '1'
FILES_${PN} = "/opt/bin/caltool \
               /opt/conf/ \
"
