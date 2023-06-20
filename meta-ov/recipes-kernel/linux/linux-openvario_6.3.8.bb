DESCRIPTION = "Linux kernel for OpenVario"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

inherit kernel kernel-yocto siteinfo

S = "${WORKDIR}/git"

KBRANCH = "linux-6.3.y"

SRCREV = "a70bf5cc6bd9c273b8f1dd849839eca57ae76df1"

SRC_URI = " \
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=${KBRANCH} \
	\
	file://defconfig \
	\
	file://systemd.cfg \
	file://no_debug.cfg \
        file://openvario.cfg \
	file://cpufreq.cfg \
        file://usbhost.cfg \
        file://networking.cfg \
        file://netdev.cfg \
        file://usbnet.cfg \
        file://usbserial.cfg \
        file://usbstorage.cfg \
        file://filesystems.cfg \
	file://graphics.cfg \
	file://sound.cfg \
	file://wifi.cfg \
	file://bluetooth.cfg \
	file://w1.cfg \
	file://debloat.cfg \
"

SRC_URI:append:sunxi = " \
	file://0004-Set-minimum-CPU-voltage-to-1.2V.patch\
	\
	file://openvario-common.dts \
	file://openvario-43-rgb.dts \
	file://openvario-57-lvds-DS2.dts \
	file://openvario-57-lvds.dts \
	file://openvario-7-AM070-DS2.dts \
	file://openvario-7-CH070-DS2.dts \
	file://openvario-7-CH070.dts \
	file://openvario-7-PQ070.dts \
	\
	file://sunxi.cfg \
	file://drm.cfg \
"

SRC_URI[md5sum] = "0751179f60de73eb2cd93f161fa52fcf"
SRC_URI[sha256sum] = "3b84e13abae26af17ebccc4d7212f5843a991127a73a320848d5c6942ef781a2"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"
KCONFIG_MODE ?= "alldefconfig"
KMACHINE ?= "${MACHINE}"

# This kludge works around a failure to create
# "linux-*/meta/cfg/invalid.txt" because the "meta" directory does not
# exist.
KMETA = ".kernel-meta"

do_configure:prepend:sunxi() {
	cp ${WORKDIR}/openvario-*.dts ${S}/arch/arm/boot/dts/
}

FILES_${KERNEL_PACKAGE_NAME}-base:append = " ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo"
