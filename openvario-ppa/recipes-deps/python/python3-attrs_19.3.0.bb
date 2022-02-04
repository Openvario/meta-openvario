# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "Classes Without Boilerplate"
HOMEPAGE = "https://www.attrs.org/"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   docs/license.rst
# NOTE: Original package / source metadata indicates license is: MIT
#
# NOTE: multiple licenses have been detected; they have been separated with &
# in the LICENSE value for now since it is a reasonable assumption that all
# of the licenses apply. If instead there is a choice between the multiple
# licenses then you should change the value to separate the licenses with |
# instead of &. If there is any doubt, check the accompanying documentation
# to determine which situation is applicable.
LICENSE = "MIT & Unknown"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d4ab25949a73fe7d4fdee93bcbdbf8ff \
                    file://docs/license.rst;md5=0da481b581a7a2a95b0546f5968519cf"

SRC_URI[md5sum] = "5b2db50fcc31be34d32798183c9bd062"
SRC_URI[sha256sum] = "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"

S = "${WORKDIR}/attrs-${PV}"

inherit pypi setuptools3

# WARNING: the following rdepends are determined through basic analysis of the
# python sources, and might not be 100% accurate.
RDEPENDS:${PN} += "python3-core python3-pickle"

# WARNING: We were unable to map the following python package/module
# dependencies to the bitbake packages which include them:
#    attr
#    attr._compat
#    attr._make
#    attr.converters
#    attr.exceptions
#    attr.filters
#    attr.validators
#    hypothesis
#    hypothesis.strategies
#    pympler.asizeof
#    pytest
#    six
#    typing
#    zope.interface


