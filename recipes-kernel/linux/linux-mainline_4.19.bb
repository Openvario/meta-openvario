SECTION = "kernel"
DESCRIPTION = "Mainline Linux kernel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"
COMPATIBLE_MACHINE = "(sun4i|sun5i|sun7i|sun8i|sun50i)"

inherit kernel

require linux.inc

# Since we're not using git, this doesn't make a difference, but we need to fill
# in something or kernel-yocto.bbclass will fail.
KBRANCH ?= "master"

# Pull in the devicetree files into the rootfs
RDEPENDS_${KERNEL_PACKAGE_NAME}-base += "kernel-devicetree"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

# Default is to use stable kernel version
# If you want to use latest git version set to "1"
#DEFAULT_PREFERENCE = "-1"

S = "${WORKDIR}/linux-${PV}"
	
SRC_URI[md5sum] = "740a90cf810c2105df8ee12e5d0bb900"
SRC_URI[sha256sum] = "0c68f5655528aed4f99dae71a5b259edc93239fa899e2df79c055275c21749a1"

SRC_URI = "https://www.kernel.org/pub/linux/kernel/v4.x/linux-${PV}.tar.xz \
			file://defconfig \
			file://openvario.dts \
        "

do_configure_prepend() {
    cp ${WORKDIR}/openvario.dts ${S}/arch/arm/boot/dts/openvario.dts
}