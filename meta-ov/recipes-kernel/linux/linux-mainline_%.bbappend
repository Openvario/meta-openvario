FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://openvario-common.dts \
	file://openvario-43-rgb.dts \
	file://openvario-57-lvds-DS2.dts \
	file://openvario-57-lvds.dts \
	file://openvario-7-AM070-DS2.dts \
	file://openvario-7-CH070-DS2.dts \
	file://openvario-7-CH070.dts \
	file://openvario-7-PQ070.dts \
	file://openvario-common.dts \
	file://debloat.cfg \
	file://no_debug.cfg \
        file://openvario.cfg \
	file://cpufreq.cfg \
        file://networking.cfg \
        file://netdev.cfg \
        file://usbnet.cfg \
        file://usbserial.cfg \
        file://filesystems.cfg \
	file://graphics.cfg \
	file://sound.cfg \
	file://wifi.cfg \
	file://bluetooth.cfg \
	file://w1.cfg \
"

SRC_URI:append:sunxi = " \
	file://sunxi.cfg \
"

SRC_URI:append = " file://0002-Allow-to-set-duty-cycle-before-turning-off-the-PWM.patch"

SRC_URI:append = " \
	file://0001-pwm-sun4i-convert-next_period-to-local-variable.patch \
	file://0002-pwm-sun4i-calculate-delay_jiffies-directly-eliminate.patch \
	file://0003-pwm-sun4i-calculate-the-delay-without-rounding-down-.patch \
"

PR = "r0"

# This kludge works around a failure to create
# "linux-*/meta/cfg/invalid.txt" because the "meta" directory does not
# exist.
KMETA = ".kernel-meta"

do_configure:prepend() {
    if test -n "${KERNEL_DEVICETREE_SOURCE}"; then
        cp ${WORKDIR}/openvario-common.dts ${S}/arch/arm/boot/dts/openvario-common.dts
        cp ${WORKDIR}/${KERNEL_DEVICETREE_SOURCE} ${S}/arch/arm/boot/dts/openvario.dts
    fi
}
