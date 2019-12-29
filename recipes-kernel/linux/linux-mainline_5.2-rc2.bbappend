FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://openvario.dts"

do_configure_prepend() {
    cp ${WORKDIR}/openvario.dts ${S}/arch/arm/boot/dts/openvario.dts
}
