# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "r10"

inherit systemd
SRCREV:pn-sensord-testing = "${AUTOREV}"

SRC_URI = "git://github.com/Openvario/sensord.git;protocol=https;branch=master \
			file://sensord.cfgmgr \			  
	file://sensord.socket \
	file://sensord@.service \
"

require sensord.inc

do_install:append() {
	install -d ${D}/opt/conf/default
	install -d ${D}/etc/cfgmgr.d
	install -m 0755 ${S}/compdata ${D}/opt/bin
	install -m 0755 ${S}/sensord.conf ${D}/opt/conf/default/sensord.conf
	install -m 0755 ${WORKDIR}/sensord.cfgmgr ${D}/etc/cfgmgr.d/sensord.cfgmgr
	install -m 0644 ${WORKDIR}/sensord.socket ${WORKDIR}/sensord@.service ${D}${systemd_unitdir}/system

	# obsolete in sensord-testing
	rm -f ${D}${systemd_unitdir}/system/sensord.service
}

# obsolete in sensord-testing
SYSTEMD_SERVICE:${PN}:remove = "sensord.service"
FILES:${PN}:remove = "${systemd_unitdir}/system/sensord.service"

FILES:${PN} += " \
					/opt/bin/compdata \
					/opt/conf/default/sensord.conf \
					/etc/cfgmgr.d/sensord.cfgmgr \
        ${systemd_unitdir}/system/sensord.socket \
        ${systemd_unitdir}/system/sensord@.service \
"
