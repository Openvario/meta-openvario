# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar Maps"
HOMEPAGE = ""
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
SECTION = "base/app"

S = "${WORKDIR}"
PR = "r2"

#SRC_URI =	"http://download.xcsoar.org/maps/GER_HighRes.xcm;name=germanmap \
#				http://download.xcsoar.org/maps/ALPS_HighRes.xcm;name=alpsmap \
#				http://www.flarmnet.org/files/data.fln;name=flarmnet \
#				http://www.daec.de/fileadmin/user_upload/files/2012/fachbereiche/luftraum/20140306OpenAir.txt;name=airspacede \
#				http://www.austrocontrol.at/jart/prj3/austro_control/data/uploads/austria_ATS_2011_openair.txt;name=airspaceat \
#"

SRC_URI =      "http://download.xcsoar.org/maps/GER_HighRes.xcm;name=germanmap \
                               http://download.xcsoar.org/maps/ALPS_HighRes.xcm;name=alpsmap \
                               http://www.flarmnet.org/files/data.fln;name=flarmnet \
                               http://www.daec.de/fileadmin/user_upload/files/2012/fachbereiche/luftraum/20140306OpenAir.txt;name=airspacede \
"


SRC_URI[germanmap.md5sum] = "1b3d0345c8970580fdab3778a2568ca7"
SRC_URI[germanmap.sha256sum] = "54f6320e999a9aadb1af453369ac7f9b608b37063d83c6b33c9bd870c2877fba"
SRC_URI[alpsmap.md5sum] = "395f93909c1053e4c17bb8c90ff38fbe"
SRC_URI[alpsmap.sha256sum] = "1a50789146891565415fd0639d3d2ed0874c7b82c4aa5ab1252f982ff982f676"
SRC_URI[flarmnet.md5sum] = "e84c5c163e8db44f8543c87f90f191ce"
SRC_URI[flarmnet.sha256sum] = "8c506aeb1b1bbe6fdcbec6ce5ee15556a5e7eb6a6f73065281e86da5c58da6be"
SRC_URI[airspacede.md5sum] = "02096949c867fde7b7dce6c360e23c69"
SRC_URI[airspacede.sha256sum] = "bb636d4328576b8f5d1a794689f30e44059828f349c190e4e5209bc6ee307341"

addtask do_package_write_ipk after do_package after do_install

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/home/root/.xcsoar
        install -m 0755 ${S}/*.xcm ${D}/home/root/.xcsoar/
		  install -m 0755 ${S}/*.txt ${D}/home/root/.xcsoar/
        install -m 0755 ${S}/data.fln ${D}/home/root/.xcsoar/
}

FILES_${PN} = "/home/root/.xcsoar/*"

