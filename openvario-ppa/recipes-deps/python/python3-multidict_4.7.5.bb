# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "multidict implementation"
HOMEPAGE = "https://github.com/aio-libs/multidict"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   LICENSE
LICENSE = "Apache"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e74c98abe0de8f798ca609137f9cef4a"

SRC_URI[md5sum] = "9a1ed2cc0cd3e5dd2e71921104f2b760"
SRC_URI[sha256sum] = "aee283c49601fa4c13adc64c09c978838a7e812f85377ae130a24d7198c0331e"

S = "${WORKDIR}/multidict-${PV}"

inherit pypi setuptools3

# WARNING: the following rdepends are determined through basic analysis of the
# python sources, and might not be 100% accurate.
RDEPENDS_${PN} += "python3-core"

# WARNING: We were unable to map the following python package/module
# dependencies to the bitbake packages which include them:
#    collections.abc
#    multidict._multidict


