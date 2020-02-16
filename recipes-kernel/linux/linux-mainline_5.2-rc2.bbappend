FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Support-LVDS-output-on-Allwinner-A20.patch \
    file://openvario-common.dts \
    file://${KERNEL_DEVICETREE_SOURCE}"

do_configure_prepend() {
    cp ${WORKDIR}/openvario-common.dts ${S}/arch/arm/boot/dts/openvario-common.dts
    cp ${WORKDIR}/${KERNEL_DEVICETREE_SOURCE} ${S}/arch/arm/boot/dts/openvario.dts
}
