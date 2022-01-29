SUMMARY = "Competition Manager for OpenVario"
HOMEPAGE = "https://github.com/kedder/openvario-compman"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"
RECIPE_MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"
MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"
PYPI_PACKAGE = "openvario-compman"

SRC_URI[sha256sum] = "cc343edb899bd3df6eeba1e222ca234efbdc2e04f313b6fe879cd8f35c089157"

inherit pypi setuptools3

RDEPENDS_${PN} += "python3-aiodns python3-requests python3-aiohttp python3-lxml python3-urwid python3-setuptools "
RDEPENDS_${PN} += "python3-core"
