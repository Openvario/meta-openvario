DESCRIPTION = "Linux Kernel for Openvario Raspberry Pi"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

COMPATIBLE_MACHINE ?= "^rpi$"

PE = "1"
PV = "${LINUX_VERSION}+git${SRCPV}"

LINUX_VERSION ?= "6.6.22"
LINUX_RPI_BRANCH ?= "rpi-6.6.y"
LINUX_RPI_KMETA_BRANCH ?= "yocto-6.6"

SRCREV_machine = "c04af98514c26014a4f29ec87b3ece95626059bd"
SRCREV_meta = "6a24861d6504575a4a9f92366285332d47c7e111"

inherit siteinfo
require recipes-kernel/linux/linux-yocto.inc

SRC_URI = "git://github.com/raspberrypi/linux.git;name=machine;branch=${LINUX_RPI_BRANCH};protocol=https \
           git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=${LINUX_RPI_KMETA_BRANCH};destsuffix=kernel-meta \
           file://powersave.cfg \
           file://lvds_bridge.cfg \
           file://debloat.cfg \
           file://console.cfg \
           ${@bb.utils.contains("INITRAMFS_IMAGE_BUNDLE", "1", "file://initramfs-image-bundle.cfg", "", d)} \
           ${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "file://vc4graphics.cfg", "", d)} \
           ${@bb.utils.contains("MACHINE_FEATURES", "wm8960", "file://wm8960.cfg", "", d)} \
           file://default-cpu-governor.cfg \
           file://rpi4-nvmem.cfg \
           file://0001-Added-openvario-overlays.patch \
           file://ov-cm4-57-lvds-overlay.dts;subdir=git/arch/arm/boot/dts/overlays \
           file://ov-cm4-7-pq070-overlay.dts;subdir=git/arch/arm/boot/dts/overlays \
           file://rpi4-nvmem.cfg \
           "

SRC_URI:append:raspberrypi4 = " \
    file://rpi4-nvmem.cfg \
"

KCONFIG_MODE = "--alldefconfig"
KBUILD_DEFCONFIG:raspberrypi4 ?= "bcm2711_defconfig"
KBUILD_DEFCONFIG:raspberrypi4-64 ?= "bcm2711_defconfig"

LINUX_VERSION_EXTENSION ?= ""

KERNEL_MODULE_AUTOLOAD += "${@bb.utils.contains("MACHINE_FEATURES", "pitft28r", "stmpe-ts", "", d)}"
KERNEL_MODULE_AUTOLOAD:rpi += "i2c-dev i2c-bcm2708"

# A LOADADDR is needed when building a uImage format kernel. This value is not
# set by default in rpi-4.8.y and later branches so we need to provide it
# manually. This value unused if KERNEL_IMAGETYPE is not uImage.
KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

UBOOT_ENTRYPOINT =       "0x00008000"
UBOOT_LOADADDRESS =      "0x00008000"


KERNEL_DTC_FLAGS += "-@ -H epapr"

RDEPENDS:${KERNEL_PACKAGE_NAME}:raspberrypi-armv7:append = " ${RASPBERRYPI_v7_KERNEL_PACKAGE_NAME}"
RDEPENDS:${KERNEL_PACKAGE_NAME}-base:raspberrypi-armv7:append = " ${RASPBERRYPI_v7_KERNEL_PACKAGE_NAME}-base"
RDEPENDS:${KERNEL_PACKAGE_NAME}-image:raspberrypi-armv7:append = " ${RASPBERRYPI_v7_KERNEL_PACKAGE_NAME}-image"
RDEPENDS:${KERNEL_PACKAGE_NAME}-dev:raspberrypi-armv7:append = " ${RASPBERRYPI_v7_KERNEL_PACKAGE_NAME}-dev"
RDEPENDS:${KERNEL_PACKAGE_NAME}-vmlinux:raspberrypi-armv7:append = " ${RASPBERRYPI_v7_KERNEL_PACKAGE_NAME}-vmlinux"
RDEPENDS:${KERNEL_PACKAGE_NAME}-modules:raspberrypi-armv7:append = " ${RASPBERRYPI_v7_KERNEL_PACKAGE_NAME}-modules"
RDEPENDS:${KERNEL_PACKAGE_NAME}-dbg:raspberrypi-armv7:append = " ${RASPBERRYPI_v7_KERNEL_PACKAGE_NAME}-dbg"

DEPLOYDEP = ""
DEPLOYDEP:raspberrypi-armv7 = "${RASPBERRYPI_v7_KERNEL}:do_deploy"
do_deploy[depends] += "${DEPLOYDEP}"
