# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OpenVario Tools (startmenu, touch calibration, etc.)"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"
DEPENDS = "ncurses udev libinput"
RDEPENDS_${PN} = "ncurses libudev libinput"
PR = "r1"

S = "${WORKDIR}/git"

SRC_URI = "git://git-ro.openvario.org/ovmenu.git;protocol=http;rev=master\
"

do_compile() {
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git
	make
}

do_install() {
	install -d ${D}/opt/bin
	install -m 0755 ${S}/ovmenu/ovmenu ${D}/opt/bin
	install -m 0755 ${S}/caltool/caltool ${D}/opt/bin
	install -m 0755 ${S}/caltool/touchscreen.rules.template ${D}/opt/bin
	install -m 0755 ${S}/caltool/calibrate_landscape.sh ${D}/opt/bin
	install -m 0755 ${S}/caltool/calibrate_portrait.sh ${D}/opt/bin
}

PACKAGES = "${PN}"
FILES_${PN} = "  \
		/opt/bin/ovmenu \
		/opt/bin/caltool \
		/opt/bin/touchscreen.rules.template \
		/opt/bin/calibrate_landscape.sh \
		/opt/bin/calibrate_portrait.sh \
"
