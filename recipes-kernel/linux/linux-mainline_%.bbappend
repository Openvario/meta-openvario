FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://openvario-common.dts \
	file://openvario-43-rgb.dts \
	file://openvario-57-lvds-DS2.dts \
	file://openvario-57-lvds.dts \
	file://openvario-7-AM070-DS2.dts \
	file://openvario-7-CH070-DS2.dts \
	file://openvario-7-CH070.dts \
	file://openvario-7-PQ070.dts \
	file://openvario-common.dts \
        file://openvario.cfg \
        file://networking.cfg \
        file://netdev.cfg \
        file://usbnet.cfg \
        file://usbserial.cfg \
        file://filesystems.cfg \
"

SRC_URI_append = " file://lima.conf"
SRC_URI_append = " file://0002-Allow-to-set-duty-cycle-before-turning-off-the-PWM.patch"

PR = "r0"

do_configure_prepend() {
    if test -n "${KERNEL_DEVICETREE_SOURCE}"; then
        cp ${WORKDIR}/openvario-common.dts ${S}/arch/arm/boot/dts/openvario-common.dts
        cp ${WORKDIR}/${KERNEL_DEVICETREE_SOURCE} ${S}/arch/arm/boot/dts/openvario.dts
    fi
}

do_install_append() {
    # without this driver XCSoar crashes!
    install -d ${D}/etc/modprobe.d
    install -m 0644 ${WORKDIR}/lima.conf ${D}/etc/modprobe.d/lima.conf
}
