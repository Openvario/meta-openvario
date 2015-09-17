# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu skripts (eg. dynamic config, ...)"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r5"

RDEPENDS_${PN} = "bash"

SRC_URI =      "\
	file://xcsoar_config.sh \
	file://update-maps.sh \
	file://update-system.sh \
	file://download-igc.sh \
	file://upload-all.sh \
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
		install -m 0755 ${S}/download-igc.sh ${D}/usr/bin/upload-all.sh
}

FILES_${PN} = "/usr/bin/xcsoar_config.sh \
				/usr/bin/update-maps.sh \
				/usr/bin/update-system.sh \
				/usr/bin/download-igc.sh \
				/usr/bin/upload-all.sh \
"
