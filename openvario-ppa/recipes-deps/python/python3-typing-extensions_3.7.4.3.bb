SUMMARY = "Backported and Experimental Type Hints for Python 3.5+"
HOMEPAGE = "https://github.com/python/typing/blob/master/typing_extensions/README.rst"
LICENSE = "PSF"
LIC_FILES_CHKSUM = "file://LICENSE;md5=64fc2b30b67d0a8423c250e0386ed72f"

SRC_URI = "https://files.pythonhosted.org/packages/6a/28/d32852f2af6b5ead85d396249d5bdf450833f3a69896d76eb480d9c5e406/typing_extensions-${PV}.tar.gz"
SRC_URI[md5sum] = "5fcbfcb22e6f8c9bf23fb9f8e020f6ee"
SRC_URI[sha256sum] = "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"

S = "${WORKDIR}/typing_extensions-${PV}"

inherit setuptools3

RDEPENDS:${PN} += "python3-core"
