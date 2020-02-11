FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Support-LVDS-output-on-Allwinner-A20.patch \
    file://openvario.dts"

do_configure_prepend() {
    cp ${WORKDIR}/openvario.dts ${S}/arch/arm/boot/dts/openvario.dts
}
