DESCRIPTION="Upstream's U-boot configured for sunxi devices"

require recipes-bsp/u-boot/u-boot.inc

DEPENDS += " bc-native dtc-native swig-native python3-native flex-native bison-native "

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"

COMPATIBLE_MACHINE = "(sun7i)"

DEFAULT_PREFERENCE_sun7i="1"

SRC_URI = "git://git.denx.de/u-boot.git;branch=master \
           file://boot.cmd \
           file://openvario_defconfig \
           file://openvario.dts \
           file://ov_recover_0.bmp \
	       file://ov_recover_1.bmp \
	       file://ov_recover_2.bmp \
	       file://ov_recover_3.bmp \
	       file://ov_booting_0.bmp \
	       file://ov_booting_1.bmp \
	       file://ov_booting_2.bmp \
	       file://ov_booting_3.bmp \
	       file://0001-Added-openvario.dts-to-Makefile.patch \
		   file://0001-Added-RGB-swap-for-RGB-LCD.patch \
	       file://0001-Environment-Openvario-mainline.patch \
	       file://config.uEnv \
           "

SRCREV = "3c99166441bf3ea325af2da83cfe65430b49c066"

PV = "v2019.04+git${SRCPV}"

S = "${WORKDIR}/git"

UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV = "boot"

EXTRA_OEMAKE += ' HOSTLDSHARED="${BUILD_CC} -shared ${BUILD_LDFLAGS} ${BUILD_CFLAGS}" '

do_configure_prepend() {
    cp ${WORKDIR}/openvario_defconfig ${S}/configs/openvario_defconfig
	cp ${WORKDIR}/openvario.dts ${S}/arch/arm/dts/openvario.dts
}

do_compile_append() {
    ${B}/tools/mkimage -C none -A arm -T script -d ${WORKDIR}/boot.cmd ${WORKDIR}/${UBOOT_ENV_BINARY}
}

do_install_append() {
    if [ -e ${WORKDIR}/ov_recover_0.bmp ] ; then
	install -m 644 -D ${WORKDIR}/ov_*.bmp ${D}/boot
    fi
	
	if [ -e ${WORKDIR}/config.uEnv ] ; then
	install -m 644 -D ${WORKDIR}/config.uEnv ${D}/boot
    fi
}

do_deploy_append() {
    if [ -e ${WORKDIR}/ov_recover_0.bmp ] ; then
	install -d ${DEPLOYDIR}/pics
        install -m 644 -D ${WORKDIR}/ov_*.bmp ${DEPLOYDIR}/pics
    fi
	
	if [ -e ${WORKDIR}/config.uEnv ] ; then
	install -m 644 -D ${WORKDIR}/config.uEnv ${DEPLOYDIR} 
    fi
}
