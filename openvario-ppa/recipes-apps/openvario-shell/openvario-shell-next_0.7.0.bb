SUMMARY = "Main Menu Shell for Openvario"
HOMEPAGE = "https://github.com/kedder/openvario-shell"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"
RECIPE_MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"
MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"
PYPI_PACKAGE = "openvario-shell"
PR = "r1"

SRC_URI[sha256sum] = "033e4527c9a9bc784bfa5c500f9f4439798a29b7a1373e1ba638523850bc6bd7"

inherit pypi setuptools3

RDEPENDS_${PN} += " \
    python3-core \
    python3-typing-extensions \
    python3-urwid \
    python3-setuptools \
    python3-misc \
    python3-asyncio \
    python3-dbus-next \
    python3-json \
    python3-pyserial \
    python3-pyserial-asyncio \
    rsync \
    zap-console-fonts \
"
