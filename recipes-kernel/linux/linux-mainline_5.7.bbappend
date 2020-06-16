FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://openvario-common.dts \
    file://${KERNEL_DEVICETREE_SOURCE} \
    file://lima.conf \
    file://0001-drm-lima-Expose-job_hang_limit-module-parameter.patch \
"

PR = "r0"

do_configure_prepend() {
    cp ${WORKDIR}/openvario-common.dts ${S}/arch/arm/boot/dts/openvario-common.dts
    cp ${WORKDIR}/${KERNEL_DEVICETREE_SOURCE} ${S}/arch/arm/boot/dts/openvario.dts
}

do_install_append() {
    install -d ${D}/etc/modprobe.d
    install -m 0644 ${WORKDIR}/lima.conf ${D}/etc/modprobe.d/lima.conf
}