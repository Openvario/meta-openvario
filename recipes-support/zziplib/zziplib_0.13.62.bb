DESCRIPTION = "Support library for dealing with zip files"
SECTION = "libs"
PRIORITY = "optional"
LICENSE = "LGPL MPL"
LIC_FILES_CHKSUM = "file://COPYING.LIB;md5=55ca817ccb7d5b5b66355690e9abc605"
DEPENDS = "zlib"

PR = "r0"

SRC_URI[md5sum] = "5fe874946390f939ee8f4abe9624b96c"
SRC_URI[sha256sum] = "a1b8033f1a1fd6385f4820b01ee32d8eca818409235d22caf5119e0078c7525b"

SRC_URI = "${SOURCEFORGE_MIRROR}/zziplib/zziplib-${PV}.tar.bz2 \
		file://configure.ac.patch"


inherit autotools pkgconfig

EXTRA_OECONF = "--with-zlib"
