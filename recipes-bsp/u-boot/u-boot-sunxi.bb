DESCRIPTION = "U-Boot port for sunxi"

require recipes-bsp/u-boot/u-boot.inc

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

# No patches for other machines yet
COMPATIBLE_MACHINE = "(openvario-43rgb|openvario-7lvds|openvario-57lvds)"

DEFAULT_PREFERENCE_openvario-7lvds="1"
DEFAULT_PREFERENCE_openvario-43rgb="1"
DEFAULT_PREFERENCE_openvario-57lvds="1"

SRC_URI = "git://github.com/linux-sunxi/u-boot-sunxi.git;protocol=git;branch=sunxi"

PE = "1"

PV = "v2014.04+git${SRCPV}"
# Corresponds 2014.04 in Makefile
SRCREV = "ea1ac32bf76eb60baef474c2516fc431b381d952"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SPL_BINARY="u-boot-sunxi-with-spl.bin"
