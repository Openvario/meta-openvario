# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu Next-Generation"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
require ov-revision.inc
# PR = "r21"


inherit allarch systemd

RDEPENDS:${PN} = " \
	bash \
	dialog \
	ovmenu-ng-skripts \
	ov-system-init \
	autofs-config \
"

# the "autologin" package is obsolete and interferes with this one
# the "autostart" package was merged into this one
RCONFLICTS:${PN} = " \
	openvario-autologin \
	ovmenu-ng-autostart \
"

SRC_URI = "\
	file://ovmenu-ng.sh \
	file://ovmenu-ng-opensoar.sh \
	file://ovmenu-ng-xcsoar.sh \
	file://openvario.rc \
	file://${BPN}.service \
	file://disable_dropbear.preset \
"


addtask do_package_write_ipk after do_package

do_compile() {
	:
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/ovmenu-ng.sh ${D}${bindir}/ovmenu-ng.sh
	install -m 0755 ${S}/ovmenu-ng-opensoar.sh ${D}${bindir}/ovmenu-ng-opensoar.sh
	install -m 0755 ${S}/ovmenu-ng-xcsoar.sh ${D}${bindir}/ovmenu-ng-xcsoar.sh
	install -d ${D}${ROOT_HOME}
	install -d ${D}${ROOT_HOME}/.xcsoar
	install -d ${D}${ROOT_HOME}/data  # mount dir for data partition!
	install -m 0755 ${S}/openvario.rc ${D}${ROOT_HOME}/.dialogrc
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/ovmenu-ng.service ${D}${systemd_unitdir}/system

	# TODO: move this preset file to a more appropriate recipe
	install -d ${D}${systemd_unitdir}/system-preset
	install -m 0644 ${WORKDIR}/disable_dropbear.preset ${D}${systemd_unitdir}/system-preset/50-disable_dropbear.preset

	if [ "${MACHINE}" = "sunxi" ]; then
		install -m 0644 ${DEPLOY_DIR_IMAGE}/ov-recovery.itb ${D}/${bindir}
	fi

}

SYSTEMD_SERVICE:${PN} = "${PN}.service"

FILES:${PN} = " \
	${bindir}/ovmenu-ng.sh \
	${bindir}/ovmenu-ng-opensoar.sh \
	${bindir}/ovmenu-ng-xcsoar.sh \
	${bindir}/ov-recovery.itb \
	${ROOT_HOME}/.dialogrc \
	${systemd_unitdir}/system-preset/50-disable_dropbear.preset \
	${ROOT_HOME}/.xcsoar/ \
	${ROOT_HOME}/data/ \
"
