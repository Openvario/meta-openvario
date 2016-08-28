SECTION = "kernel"
DESCRIPTION = "Mainline Linux kernel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"
COMPATIBLE_MACHINE = "(openvario-7-PQ070|openvario-7-CH070|openvario-43rgb|openvario-57lvds)"

inherit kernel

require recipes-kernel/linux/linux-dtb.inc
require linux.inc

# Pull in the devicetree files into the rootfs
RDEPENDS_kernel-base += "kernel-devicetree"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

S = "${WORKDIR}/linux-${PV}"
	
SRC_URI[md5sum] = "efc822dad2149e40cc908718a4fea1d3"
SRC_URI[sha256sum] = "a3bccec4c28939355cd415672414583ecaf5531a87ddb44c9dc036aeacec577d"

SRC_URI = "https://www.kernel.org/pub/linux/kernel/v4.x/linux-${PV}.tar.xz \
		file://0001-gpu-ported-Mali400-a.-Ump-driver-from-linux-sunxi-ke.patch \
        file://defconfig \
        "