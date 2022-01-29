# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "Python binding to the Brotli library"
HOMEPAGE = "https://github.com/python-hyper/brotlipy/"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ae57d8a09fc8b6b164d7357339619045 \
                    file://libbrotli/LICENSE;md5=941ee9cd1609382f946352712a319b4b"

SRC_URI[md5sum] = "300a63158cec5b74082625dd9a2ae4d2"
SRC_URI[sha256sum] = "36def0b859beaf21910157b4c33eb3b06d8ce459c942102f16988cca6ea164df"

S = "${WORKDIR}/brotlipy-${PV}"

DEPENDS += " python3-cffi-native "

inherit pypi setuptools3

# The following configs & dependencies are from setuptools extras_require.
# These dependencies are optional, hence can be controlled via PACKAGECONFIG.
# The upstream names may not correspond exactly to bitbake package names.
#
# Uncomment this line to enable all the optional features.
#PACKAGECONFIG ?= ":python_version == "2.7" or python_version == "3.3""

# WARNING: the following rdepends are from setuptools install_requires. These
# upstream names may not correspond exactly to bitbake package names.
RDEPENDS_${PN} += "python3-cffi"

# WARNING: the following rdepends are determined through basic analysis of the
# python sources, and might not be 100% accurate.
RDEPENDS_${PN} += "python3-core"


