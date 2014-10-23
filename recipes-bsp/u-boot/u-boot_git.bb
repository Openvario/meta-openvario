require u-boot.inc

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

# No patches for other machines yet
COMPATIBLE_MACHINE = "(openvario-43rgb|openvario-7lvds)"

DEFAULT_PREFERENCE_openvario-7lvds="1"
DEFAULT_PREFERENCE_openvario-43rgb="1"

SRC_URI = "git://github.com/linux-sunxi/u-boot-sunxi.git;protocol=git;branch=sunxi"

PE = "1"
PV = "v2013.10+v2014.01-rc1"
SRCREV = "d854c4de2f57107e35893c591f856f8f6d0ccc5d"


S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SPL_BINARY="u-boot-sunxi-with-spl.bin"

