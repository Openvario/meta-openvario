DESCRIPTION = "Python HTTP for Humans."
HOMEPAGE = "http://python-requests.org"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=34400b68072d710fecd0a2940a0d1658"

FILESEXTRAPATHS_prepend := "${THISDIR}/python-requests:"

SRC_URI[md5sum] = "8c745949ad3e9ae83d9927fed213db8a"
SRC_URI[sha256sum] = "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"

inherit pypi setuptools3

RDEPENDS_${PN} += " \
    ${PYTHON_PN}-email \
    ${PYTHON_PN}-json \
    ${PYTHON_PN}-ndg-httpsclient \
    ${PYTHON_PN}-netserver \
    ${PYTHON_PN}-pyasn1 \
    ${PYTHON_PN}-pyopenssl \
    ${PYTHON_PN}-pysocks \
    ${PYTHON_PN}-urllib3 \
    ${PYTHON_PN}-chardet \
    ${PYTHON_PN}-idna \
    ${PYTHON_PN}-charset-normalizer \
"

CVE_PRODUCT = "requests"

BBCLASSEXTEND = "native nativesdk"
