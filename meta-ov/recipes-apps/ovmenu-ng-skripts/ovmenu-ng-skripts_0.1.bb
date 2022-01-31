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
"

SRC_URI =      "\
	file://xcsoar_config.sh \
	file://update-maps.sh \
	file://update-system.sh \
	file://download-igc.sh \
	file://upload-all.sh \
	file://upload-xcsoar.sh \
	file://download-all.sh \
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
		${S}/xcsoar_config.sh \
		${S}/update-maps.sh \
		${S}/update-system.sh \
		${S}/download-igc.sh \
		${S}/upload-all.sh \
		${S}/upload-xcsoar.sh \
		${S}/download-all.sh \
		${S}/ov-calibrate-ts.sh \
		${D}${bindir}/
}

FILES:${PN} = " \
	${bindir}/*.sh \
"
