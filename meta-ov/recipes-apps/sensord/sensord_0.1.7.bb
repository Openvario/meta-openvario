# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Sensord Daemon for Openvario"
HOMEPAGE = ""
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = ""
DEPENDS = ""
PR = "r1"

SRC_URI = "git://www.openvario.org/git-repos/sensord.git;protocol=http;rev=master;user=guest:Thahh3th"

do_compile() {
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git
	make sensord
}

