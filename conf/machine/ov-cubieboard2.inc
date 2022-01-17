# Common machine definitions for all Cubieboard2-based OpenVarios

# this value is recommended by meta-sunxi/README.md
DEFAULTTUNE = "cortexa7hf-neon-vfpv4"

PREFERRED_VERSION_linux-mainline ?= "5.10.%"

# use the open source "Lima" Mali GPU driver
MACHINEOVERRIDES .= ":use-mailine-graphics"

# inherit the meta-sunxi "cubieboard2" machine
require conf/machine/cubieboard2.conf
MACHINEOVERRIDES =. "cubieboard2:"

IMAGE_CLASSES += "sdcard_image-openvario"
IMAGE_FSTYPES = "openvario-sdimg"

KERNEL_DEVICETREE = "openvario.dtb"
UBOOT_MACHINE = "openvario_defconfig"
