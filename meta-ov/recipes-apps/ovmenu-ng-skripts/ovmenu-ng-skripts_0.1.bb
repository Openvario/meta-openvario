# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu skripts (eg. dynamic config, ...)"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r10"

inherit allarch

RDEPENDS:${PN} = " \
	bash \
	dialog \
	rsync \
"

SRC_URI = "\
	file://update-maps.sh \
	file://update-system.sh \
	file://download-igc.sh \
	file://transfer-xcsoar.sh \
	file://logbook.sh \
	file://ov-calibrate-ts.sh \
"


addtask do_package_write_ipk after do_package

do_compile() {
	:
}

do_install() {
	echo "Installing ..."
	install -d ${D}${bindir}
	install -m 0755 \
		${S}/update-maps.sh \
		${S}/update-system.sh \
		${S}/download-igc.sh \
		${S}/transfer-xcsoar.sh \
		${S}/logbook.sh \
		${S}/ov-calibrate-ts.sh \
		${D}${bindir}/
	cd ${D}${bindir}
	ln -s -r transfer-xcsoar.sh upload-all.sh
	ln -s -r transfer-xcsoar.sh upload-xcsoar.sh
	ln -s -r transfer-xcsoar.sh download-all.sh
}

FILES:${PN} = " \
	${bindir}/*.sh \
"
