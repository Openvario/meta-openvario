DESCRIPTION = "U-Boot mainline"
PROVIDES = "virtual/bootloader"

require recipes-bsp/u-boot/u-boot.inc

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

# No patches for other machines yet
COMPATIBLE_MACHINE = "(openvario-43rgb|openvario-7lvds|openvario-57lvds)"

DEFAULT_PREFERENCE_openvario-7lvds="1"
DEFAULT_PREFERENCE_openvario-43rgb="1"
DEFAULT_PREFERENCE_openvario-57lvds="1"

UBOOT_MACHINE = "openvario_defconfig"

SRC_URI = " \
		git://git.denx.de/u-boot.git;protocol=http \
		file://openvario_defconfig \
		file://0001-Added-RGB-swap-for-RGB-LCD.patch \
		file://0001-Environment-Openvario.patch \
"

PE = "1"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SPL_BINARY="u-boot-sunxi-with-spl.bin"

do_configure_prepend() {
	mv ${WORKDIR}/*_defconfig ${WORKDIR}/git/configs
}
