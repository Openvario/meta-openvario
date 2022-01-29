SUMMARY = "The next great DBus library for Python."
HOMEPAGE = "https://github.com/altdesktop/python-dbus-next"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=94e750c96e56788499b56c81de91431c"

SRC_URI[md5sum] = "fcf7443b379ef69f95727bec0221ebc9"
SRC_URI[sha256sum] = "f656a3d3450b670f228248ffb1c3a703a69c4a8cb10cce63b108f17c8bd6c3de"
PYPI_PACKAGE = "dbus_next"
S = "${WORKDIR}/dbus_next-${PV}"

inherit  pypi setuptools3
RDEPENDS_${PN} += "python3-codecs python3-core python3-asyncio"
