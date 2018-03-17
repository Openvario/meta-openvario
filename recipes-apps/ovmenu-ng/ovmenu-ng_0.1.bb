# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "OVMenu Next-Generation"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r15"

RDEPENDS_${PN} = " \
	bash \
	dialog-static \
	ovmenu-ng-skripts \
        ovmenu-ng-autostart \
"

SRC_URI =      "\
	file://ovmenu-ng.sh \
	file://openvario.rc \
	file://screen.conf \
	file://update-maps-lk8000.sh \
	file://download-igc-lk8000.sh \
	file://upload-lk8000.sh \
	file://download-lk8000.sh \
"


addtask do_package_write_ipk after do_package after do_install

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/opt/bin
        install -m 0755 ${S}/ovmenu-ng.sh ${D}/opt/bin/ovmenu-ng.sh
	install -d ${D}/home/root
	install -m 0755 ${S}/openvario.rc ${D}/home/root/.dialogrc
	install -d ${D}/opt/conf
	install -m 0755 ${S}/screen.conf ${D}/opt/conf/screen.conf

        install -d ${D}/usr/bin
        install -m 0755 ${S}/update-maps-lk8000.sh ${D}/usr/bin/update-maps-lk8000.sh
	install -m 0755 ${S}/download-igc-lk8000.sh ${D}/usr/bin/download-igc-lk8000.sh
	install -m 0755 ${S}/download-lk8000.sh ${D}/usr/bin/download-lk8000.sh
	install -m 0755 ${S}/upload-lk8000.sh ${D}/usr/bin/upload-lk8000.sh
}

FILES_${PN} = "/opt/bin/ovmenu-ng.sh \
				/home/root/.dialogrc \
	/opt/conf/screen.conf \
	/usr/bin/update-maps-lk8000.sh \
	/usr/bin/download-igc-lk8000.sh \
	/usr/bin/download-lk8000.sh \
	/usr/bin/upload-lk8000.sh \
"
