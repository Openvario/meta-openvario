# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "cChardet is high speed universal character encoding detector."
HOMEPAGE = "https://github.com/PyYoshi/cChardet"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   COPYING
#   src/ext/uchardet/COPYING
#
# NOTE: multiple licenses have been detected; they have been separated with &
# in the LICENSE value for now since it is a reasonable assumption that all
# of the licenses apply. If instead there is a choice between the multiple
# licenses then you should change the value to separate the licenses with |
# instead of &. If there is any doubt, check the accompanying documentation
# to determine which situation is applicable.
LICENSE = "MPL-1.1 & GPL & LGPL"
LIC_FILES_CHKSUM = "file://COPYING;md5=6ecda54f6f525388d71d6b3cd92f7474 \
                    file://src/ext/uchardet/COPYING;md5=6ecda54f6f525388d71d6b3cd92f7474"

SRC_URI[md5sum] = "681af4e6546e47e2ae856057a8a7d105"
SRC_URI[sha256sum] = "240efe3f255f916769458343840b9c6403cf3192720bc5129792cbcb88bf72fb"

S = "${WORKDIR}/cchardet-${PV}"

inherit pypi setuptools3

# WARNING: the following rdepends are determined through basic analysis of the
# python sources, and might not be 100% accurate.
RDEPENDS:${PN} += "python3-core"


