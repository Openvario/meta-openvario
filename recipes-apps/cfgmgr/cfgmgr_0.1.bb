# Copyright (C) 2016 Timo Bruderek <timo.bruderek@gmx.de>

DESCRIPTION = "Configuration Manager for Openvario Flight Computer"
HOMEPAGE = "www.openvario.org"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}/git"
PR = "r4"

SRCREV_pn-cfgmgr = "${AUTOREV}"

RDEPENDS_${PN} = " \
				python \
				python-argparse \
				python-configparser \
				python-shell \
				python-compression \
"

SRC_URI = "\
		git://git-ro.openvario.org/cfgmgr.git;protocol=http \
"


addtask do_package_write_ipk after do_package after do_install

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/opt/bin
        install -m 0755 ${S}/cfgmgr.py ${D}/opt/bin/cfgmgr.py
		install -m 0755 ${S}/ConfigFile.py ${D}/opt/bin/ConfigFile.py
}

FILES_${PN} = "/opt/bin/cfgmgr.py \
				/opt/bin/ConfigFile.py \
"
