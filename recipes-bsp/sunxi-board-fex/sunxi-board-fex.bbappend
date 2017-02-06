COMPATIBLE_MACHINE = "(openvario-7-PQ070)"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://CB2-43RGB.fex \
	file://CB2-7-CH070.fex \
	file://CB2-7-PQ070.fex \
	file://CB2-57LVDS.fex \
	"


SUNXI_FEX_FILE_openvario-43rgb = "CB2-43RGB.fex"
SUNXI_FEX_FILE_openvario-7-CH070 = "CB2-7-CH070.fex"
SUNXI_FEX_FILE_openvario-7-PQ070 = "CB2-7-PQ070.fex"
SUNXI_FEX_FILE_openvario-57lvds = "CB2-57LVDS.fex"

do_compile_prepend () {
	cp ${WORKDIR}/*.fex ${WORKDIR}/git
}