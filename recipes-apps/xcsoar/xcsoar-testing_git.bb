# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "r14"
RCONFLICTS:${PN}="xcsoar xcsoar-preview"

SRCREV:pn-xcsoar-testing = "${AUTOREV}" 

SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=https;branch=master \
	file://ovmenu-x.service \
"

inherit systemd

# dev branch is: boost 1.90:
BOOST_VERSION = "1.90.0"
BOOST_SHA256HASH = "49551aff3b22cbc5c5a9ed3dbc92f0e23ea50a0f7325b0d198b705e8ee3fc305"

require xcsoar.inc

PACKAGES += "ovmenu-x"
RDEPENDS:ovmenu-x += " \
	${PN} \
	ovmenu-ng-skripts \
	autofs-config \
"
RCONFLICTS:ovmenu-x += "ovmenu-ng-autostart"
SYSTEMD_PACKAGES = "ovmenu-x"
SYSTEMD_SERVICE:ovmenu-x = "ovmenu-x.service"

do_compile:append() {
	oe_runmake output/UNIX/bin/OpenVarioMenu
}

do_install:append() {
	install -m755 ${S}/output/UNIX/bin/OpenVarioMenu ${D}${bindir}

	install -d ${D}${systemd_unitdir}/system
	install -m644 ${WORKDIR}/ovmenu-x.service ${D}${systemd_unitdir}/system
}

FILES:ovmenu-x += "${bindir}/OpenVarioMenu"
