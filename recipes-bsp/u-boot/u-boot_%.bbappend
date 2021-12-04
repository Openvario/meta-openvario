DESCRIPTION="Upstream's U-boot configured for sunxi devices (openvario-cubiebord2)"

# ====================================================================================================
# This part is a adapted copy from layer meta-sunx/recipes-bsb/u-boot/u-boot_%.bbappend
# removed suffix '_sunxi' to use it in this script
# disabling the fields with suffix '_sun50i'

# use f.e. boot.cmd from layer meta-sunxi!
FILESEXTRAPATHS_prepend := "${THISDIR}/../../../meta-sunxi/recipes-bsp/u-boot/files:"

DEPENDS_append = " bc-native dtc-native swig-native python3-native flex-native bison-native "
# sun50i: DEPENDS_append_sun50i = " atf-sunxi "

COMPATIBLE_MACHINE = "(sun4i|sun5i|sun7i|sun8i|sun50i)"

# DEFAULT_PREFERENCE_sun4i="1"
# DEFAULT_PREFERENCE_sun5i="1"
DEFAULT_PREFERENCE_sun7i="1"
# DEFAULT_PREFERENCE_sun8i="1"
# DEFAULT_PREFERENCE_sun50i="1"

# the nanopi-neo_air isn't used in openvario :), we need only the boot.cmd:
SRC_URI_append = " file://boot.cmd "
#            file://0001-nanopi_neo_air_defconfig-Enable-eMMC-support.patch

UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV = "boot"

EXTRA_OEMAKE_append = ' HOSTLDSHARED="${BUILD_CC} -shared ${BUILD_LDFLAGS} ${BUILD_CFLAGS}" '
# EXTRA_OEMAKE_append_sun50i = " BL31=${DEPLOY_DIR_IMAGE}/bl31.bin "

# sun50i: do_compile_sun50i[depends] += "atf-sunxi:do_deploy"

do_compile_append() {
    ${B}/tools/mkimage -C none -A arm -T script -d ${WORKDIR}/boot.cmd ${WORKDIR}/${UBOOT_ENV_BINARY}
}
# ====================================================================================================
# Add the files folder to the saerch path:
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
        file://openvario_defconfig \
        file://openvario.dts \
        file://config.uEnv \
        file://ov_recover_0.bmp \
        file://ov_recover_1.bmp \
        file://ov_recover_2.bmp \
        file://ov_recover_3.bmp \
        \
        file://ov_booting_0.bmp \
        file://ov_booting_1.bmp \
        file://ov_booting_2.bmp \
        file://ov_booting_3.bmp \
        \
        file://0001-Added-openvario.dts-to-Makefile.patch \
        file://0001-Added-RGB-swap-for-RGB-LCD.patch \
        file://0001-Environment-Openvario-mainline.patch \
    "

do_configure_prepend() {
    cp ${WORKDIR}/openvario_defconfig ${S}/configs/openvario_defconfig
    cp ${WORKDIR}/openvario.dts ${S}/arch/arm/dts/openvario.dts
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
