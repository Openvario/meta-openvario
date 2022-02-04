SUMMARY = "Charset Detection, for Everyone"
HOMEPAGE = "https://github.com/ousret/charset_normalizer"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI[md5sum] = "2b2ad09c32f6c963bf9545d4eed813d8"
SRC_URI[sha256sum] = "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"

S = "${WORKDIR}/charset-normalizer-${PV}"

inherit  pypi setuptools3
RDEPENDS:${PN} += "python3-core"
