DESCRIPTION="Upstream's U-boot configured for sunxi devices"

require recipes-bsp/u-boot/u-boot.inc

DEPENDS += "dtc-native"

LICENSE = "GPLv2"

LIC_FILES_CHKSUM = "\
file://Licenses/Exceptions;md5=338a7cb1e52d0d1951f83e15319a3fe7 \
file://Licenses/bsd-2-clause.txt;md5=6a31f076f5773aabd8ff86191ad6fdd5 \
file://Licenses/bsd-3-clause.txt;md5=4a1190eac56a9db675d58ebe86eaf50c \
file://Licenses/eCos-2.0.txt;md5=b338cb12196b5175acd3aa63b0a0805c \
file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
file://Licenses/ibm-pibs.txt;md5=c49502a55e35e0a8a1dc271d944d6dba \
file://Licenses/isc.txt;md5=ec65f921308235311f34b79d844587eb \
file://Licenses/lgpl-2.0.txt;md5=5f30f0716dfdd0d91eb439ebec522ec2 \
file://Licenses/lgpl-2.1.txt;md5=4fbd65380cdd255951079008b364516c \
file://Licenses/x11.txt;md5=b46f176c847b8742db02126fb8af92e2 \
"
COMPATIBLE_MACHINE = "(openvario-43rgb|openvario-7-CH070|openvario-7-PQ070|openvario-57lvds)"

DEFAULT_PREFERENCE_openvario-43rgb="1"
DEFAULT_PREFERENCE_openvario-57lvds="1"
DEFAULT_PREFERENCE_openvario-7-CH070="1"
DEFAULT_PREFERENCE_openvario-7-PQ070="1"

SRC_URI += " \
	file://boot.cmd \
	file://openvario_defconfig \
	file://0001-Environment-Openvario.patch \
	file://0001-Added-RGB-swap-for-RGB-LCD.patch \
	file://ov_recover_0.bmp \
	file://ov_recover_1.bmp \
	file://ov_recover_2.bmp \
	file://ov_recover_3.bmp \
	file://ov_booting_0.bmp \
	file://ov_booting_1.bmp \
	file://ov_booting_2.bmp \
	file://ov_booting_3.bmp \
	file://config.uEnv \
"

SRCREV = "33711bdd4a4dce942fb5ae85a68899a8357bdd94"

PV = "v2015.07${SRCPV}"

PE = "7"

SPL_BINARY="u-boot-sunxi-with-spl.bin"

UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV = "boot"

do_configure_prepend() {
	echo "Copying defconfig ..."
	cp ${WORKDIR}/*_defconfig ${WORKDIR}/git/configs
}

do_compile_append() {
    ${S}/tools/mkimage -C none -A arm -T script -d ${WORKDIR}/boot.cmd ${WORKDIR}/${UBOOT_ENV_BINARY}
}
