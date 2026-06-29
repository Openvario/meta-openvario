DESCRIPTION = "PROJ - Cartographic projections library"
HOMEPAGE = "https://proj.org"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=f27445198ba1500f508fce2b183ce0ff"

DEPENDS = "sqlite3"

SRC_URI = "https://github.com/OSGeo/PROJ/releases/download/9.8.1/proj-9.8.1.tar.gz"
SRC_URI[sha256sum] = "af5b731c145c1d13c4e3b4eeb7d167e94e845e440f71e3496b4ed8dae0291960"

inherit cmake

EXTRA_OECMAKE = "-DBUILD_TESTING=OFF -DBUILD_APPS=OFF -DENABLE_CURL=OFF -DENABLE_TIFF=OFF"

do_install:append() {
    rm -rf ${D}${datadir}/bash-completion
}
