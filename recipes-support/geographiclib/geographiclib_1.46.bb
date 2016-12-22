DESCRIPTION = "A C++ library for geographic projections."
SECTION = "libs"
PRIORITY = "optional"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/GeographicLib-${PV}/LICENSE.txt;md5=40bea47036debc7d222994676c509c8f"

SRC_URI[md5sum] = "59acfb8b31a360de2bc49d3905ecb646"
SRC_URI[sha256sum] = "3a0606fd99fb099572ba1923f556b05b545965359edb92930a658fc99172d962"

SRC_URI = "${SOURCEFORGE_MIRROR}/geographiclib/GeographicLib-${PV}.tar.gz"


inherit cmake

OECMAKE_SOURCEPATH = " ${WORKDIR}/GeographicLib-${PV}"

FILES_${PN}-cmake = " \
	/usr/lib/cmake/GeographicLib/geographiclib-*.cmake \
"

FILES_${PN}-python = " \
	/usr/lib/python/site-packages/geographiclib/*.py \
	/usr/lib/python/site-packages/geographiclib/test/*.py \
"

FILES_${PN}-nodejs = " \
	/usr/lib/node_modules/geographiclib/package.json \
	/usr/lib/node_modules/geographiclib/*.js \
	/usr/lib/node_modules/geographiclib/README.md \
	/usr/lib/node_modules/geographiclib/LICENSE.txt \
	/usr/lib/node_modules/geographiclib/src/*.js \
	/usr/lib/node_modules/geographiclib/test/*.js \
"

FILES_${PN}-matlab = " \ 
	/usr/share/matlab/geographiclib/*.m \
	/usr/share/matlab/geographiclib/private/*.m \
	/usr/share/matlab/geographiclib-legacy/*.m \
"

PACKAGES =+ "${PN}-cmake ${PN}-python ${PN}-nodejs ${PN}-matlab"


