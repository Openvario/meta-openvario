SUMMARY = "Main Menu Shell for Openvario"
HOMEPAGE = "https://github.com/kedder/openvario-shell"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"
RECIPE_MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"
MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"
PYPI_PACKAGE = "openvario-shell"
PR = "r3"

SRC_URI[sha256sum] = "d0f31de224a186038e1ebef466c7d88b89dd9501f45a5a3b8049a3e71195ede5"

inherit pypi setuptools3

RDEPENDS:${PN} += " \
    python3-core \
    python3-profile \
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
    connman \
    autofs-config \
"
