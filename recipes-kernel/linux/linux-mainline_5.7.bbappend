FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://openvario-common.dts \
    file://${KERNEL_DEVICETREE_SOURCE} \
"

SRC_URI_append = " file://lima.conf"
SRC_URI_append = " file://0002-Allow-to-set-duty-cycle-before-turning-off-the-PWM.patch"

PR = "r0"

do_configure_prepend() {
    cp ${WORKDIR}/openvario-common.dts ${S}/arch/arm/boot/dts/openvario-common.dts
    cp ${WORKDIR}/${KERNEL_DEVICETREE_SOURCE} ${S}/arch/arm/boot/dts/openvario.dts
}

do_install_append() {
    # without this driver XCSoar crashes!
    install -d ${D}/etc/modprobe.d
    install -m 0644 ${WORKDIR}/lima.conf ${D}/etc/modprobe.d/lima.conf
}