# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu skripts (eg. dynamic config, ...)"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r9"

RDEPENDS_${PN} = "bash"

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


addtask do_package_write_ipk after do_package after do_install

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/usr/bin
        install -m 0755 ${S}/xcsoar_config.sh ${D}/usr/bin/xcsoar_config.sh
        install -m 0755 ${S}/update-maps.sh ${D}/usr/bin/update-maps.sh
		install -m 0755 ${S}/update-system.sh ${D}/usr/bin/update-system.sh
		install -m 0755 ${S}/download-igc.sh ${D}/usr/bin/download-igc.sh
		install -m 0755 ${S}/upload-all.sh ${D}/usr/bin/upload-all.sh
		install -m 0755 ${S}/upload-xcsoar.sh ${D}/usr/bin/upload-xcsoar.sh
		install -m 0755 ${S}/download-all.sh ${D}/usr/bin/download-all.sh
		install -m 0755 ${S}/ov-calibrate-ts.sh ${D}/usr/bin/ov-calibrate-ts.sh
}

FILES_${PN} = "/usr/bin/xcsoar_config.sh \
				/usr/bin/update-maps.sh \
				/usr/bin/update-system.sh \
				/usr/bin/download-igc.sh \
				/usr/bin/upload-all.sh \
				/usr/bin/download-all.sh \
				/usr/bin/upload-xcsoar.sh \
				/usr/bin/ov-calibrate-ts.sh \
"
