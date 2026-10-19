# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu skripts (eg. dynamic config, ...)"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r12"

inherit allarch

RDEPENDS:${PN} = " \
	bash \
	dialog \
	ov-system-tools \
	rsync \
"

SRC_URI = "\
	file://ov-calibrate-ts.sh \
	file://system-info.sh \
	file://fw-upgrade.sh \
	file://update-system-config.sh \
"


addtask do_package_write_ipk after do_package

do_compile() {
	:
}


do_install() {
	echo "Installing ..."
	install -d ${D}${bindir}
	install -m 0755 \
		${S}/ov-calibrate-ts.sh \
		${S}/system-info.sh \
		${S}/fw-upgrade.sh \
		${S}/update-system-config.sh \
		${D}${bindir}/
	cd ${D}${bindir}
}

FILES:${PN} = " \
	${bindir}/*.sh \
"
