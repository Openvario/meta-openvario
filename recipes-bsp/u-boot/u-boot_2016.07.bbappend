FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://openvario_defconfig \
	"
	
do_configure_prepend() {
    cp ${WORKDIR}/openvario_defconfig ${S}/configs/openvario_defconfig
}