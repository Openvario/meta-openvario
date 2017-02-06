SUMMARY = "configparser for Python"
SECTION = "devel/python"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"
SRCNAME = "configparser"
PR = "1"

SRC_URI = "https://pypi.python.org/packages/source/c/${SRCNAME}/${SRCNAME}-${PV}.tar.gz"
S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools

# FIXME might stop packaging serialwin32 and serialjava files

SRC_URI[md5sum] = "ad2a71db8bd9a017ed4735eac7acfa07"
SRC_URI[sha256sum] = "16810160ff28233efac6c1dc0eea8d4c9b87042f9210541dab4f92a90a7d8597"