# Common machine definitions for all Cubieboard2-based OpenVarios

PREFERRED_VERSION_linux-mainline ?= "5.10.%"

# use the open source "Lima" Mali GPU driver
MACHINEOVERRIDES .= ":use-mailine-graphics"

require conf/machine/include/sunxi.inc
require conf/machine/include/sunxi-mali.inc
require conf/machine/include/tune-cortexa7.inc

IMAGE_CLASSES += "sdcard_image-openvario"
IMAGE_FSTYPES = "openvario-sdimg"

SOC_FAMILY = "sun7i"

KERNEL_DEVICETREE = "openvario.dtb"
#KERNEL_DEVICETREE = "sun7i-a20-cubieboard2.dtb"
UBOOT_MACHINE = "openvario_defconfig"
SUNXI_FEX_FILE = "sys_config/a20/cubieboard2.fex"
