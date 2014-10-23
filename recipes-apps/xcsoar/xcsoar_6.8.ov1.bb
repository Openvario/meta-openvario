# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar glide computer"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = ""
DEPENDS = "libgcc"
PR = "r0"

SRC_URI = "git://www.openvario.org/git-repos/xcsoar.git;protocol=http;user=guest:Thahh3th;tag=ee730eb9db8d34fde75f06dd8589a1824d78519a"

do_compile() {
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git
	make
}

