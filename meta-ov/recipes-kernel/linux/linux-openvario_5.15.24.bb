DESCRIPTION = "Linux kernel for OpenVario"
SECTION = "kernel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

inherit kernel kernel-yocto siteinfo

# Pull in the devicetree files into the rootfs
RDEPENDS_${KERNEL_PACKAGE_NAME}-base += "kernel-devicetree"

S = "${WORKDIR}/git"

KBRANCH = "linux-5.15.y"

SRC_URI = " \
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=${KBRANCH};tag=v${PV} \
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
	file://0001-pwm-sun4i-convert-next_period-to-local-variable.patch \
	file://0002-pwm-sun4i-calculate-delay_jiffies-directly-eliminate.patch \
	file://0003-pwm-sun4i-calculate-the-delay-without-rounding-down-.patch \
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
	if test -n "${KERNEL_DEVICETREE_SOURCE}"; then
		cp ${WORKDIR}/openvario-common.dts ${S}/arch/arm/boot/dts/openvario-common.dts
		cp ${WORKDIR}/${KERNEL_DEVICETREE_SOURCE} ${S}/arch/arm/boot/dts/openvario.dts
	fi
}

FILES_${KERNEL_PACKAGE_NAME}-base:append = " ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo"
