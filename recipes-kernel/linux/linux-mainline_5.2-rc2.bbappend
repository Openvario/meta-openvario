FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Support-LVDS-output-on-Allwinner-A20.patch \
    file://openvario-common.dts \
    file://${KERNEL_DEVICETREE_SOURCE}"

PR = "r1"

# Create /etc/modprobe.d/lima.conf file
# Make sure lima loads after drm modules, so that /dev/dri/card0 would be
# claimed by sun4-drm modules (display driver) and card1 would belong to
# lima (gpu).
KERNEL_MODULE_PROBECONF = "lima"
module_conf_lima = "softdep lima pre: sun4i-drm sun4i-drm-hdmi sun4i-frontend sun4i-tcon sun4i-backend"

do_configure_prepend() {
    cp ${WORKDIR}/openvario-common.dts ${S}/arch/arm/boot/dts/openvario-common.dts
    cp ${WORKDIR}/${KERNEL_DEVICETREE_SOURCE} ${S}/arch/arm/boot/dts/openvario.dts
}
