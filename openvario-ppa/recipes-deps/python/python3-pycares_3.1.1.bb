# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "Python interface for c-ares"
HOMEPAGE = "http://github.com/saghul/pycares"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b1538fcaea82ebf2313ed648b96c69b1"

SRC_URI[md5sum] = "8ac802d79b318efa27d3a9949d0604d1"
SRC_URI[sha256sum] = "18dfd4fd300f570d6c4536c1d987b7b7673b2a9d14346592c5d6ed716df0d104"

S = "${WORKDIR}/pycares-${PV}"

DEPENDS += " python3-cffi-native "

inherit pypi setuptools3

# The following configs & dependencies are from setuptools extras_require.
# These dependencies are optional, hence can be controlled via PACKAGECONFIG.
# The upstream names may not correspond exactly to bitbake package names.
#
# Uncomment this line to enable all the optional features.
PACKAGECONFIG ?= "idna"
PACKAGECONFIG[idna] = ",,,python3-idna"

# WARNING: the following rdepends are from setuptools install_requires. These
# upstream names may not correspond exactly to bitbake package names.
RDEPENDS:${PN} += "python3-cffi"

# WARNING: the following rdepends are determined through basic analysis of the
# python sources, and might not be 100% accurate.
RDEPENDS:${PN} += "python3-core python3-io python3-math"

# WARNING: We were unable to map the following python package/module
# dependencies to the bitbake packages which include them:
#    _cffi_backend
#    collections.abc
#    pycares._cares


