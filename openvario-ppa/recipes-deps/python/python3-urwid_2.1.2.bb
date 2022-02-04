SUMMARY = "A full-featured console (xterm et al.) user interface library"
HOMEPAGE = "http://urwid.org/"
LICENSE = "LGPLv2.1 & LGPL"
LIC_FILES_CHKSUM = "file://COPYING;md5=243b725d71bb5df4a1e5920b344b86ad"

SRC_URI[md5sum] = "f7f4e6bed9ba38965dbd619520f39287"
SRC_URI[sha256sum] = "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"

S = "${WORKDIR}/urwid-${PV}"

inherit  pypi setuptools3
RDEPENDS:${PN} += "python3-codecs python3-core python3-curses python3-fcntl python3-io python3-math python3-numbers python3-shell python3-terminal"
