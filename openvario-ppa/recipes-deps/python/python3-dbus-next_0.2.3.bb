SUMMARY = "The next great DBus library for Python."
HOMEPAGE = "https://github.com/altdesktop/python-dbus-next"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=94e750c96e56788499b56c81de91431c"

SRC_URI[md5sum] = "0e31605bd90f3460aebcd0bb7fe0dc20"
SRC_URI[sha256sum] = "f4eae26909332ada528c0a3549dda8d4f088f9b365153952a408e28023a626a5"
PYPI_PACKAGE = "dbus_next"
S = "${WORKDIR}/dbus_next-${PV}"

inherit  pypi setuptools3
RDEPENDS:${PN} += "python3-codecs python3-core python3-asyncio"
