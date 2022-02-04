SUMMARY = "Competition Manager for OpenVario"
HOMEPAGE = "https://github.com/kedder/openvario-compman"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"
RECIPE_MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"
MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"
PYPI_PACKAGE = "openvario-compman"

SRC_URI[sha256sum] = "a2ffb725d8e65b5aeb866d6ac93818b3b9c1fe5d82cfeec767217ca38e7cdbf6"

inherit pypi setuptools3

RDEPENDS:${PN} += "python3-aiodns python3-requests python3-aiohttp python3-lxml python3-urwid python3-setuptools "
RDEPENDS:${PN} += "python3-core"
