# Common machine definitions for all Raspberry Pi4-based OpenVarios

MACHINEOVERRIDES =. "raspberrypi4:"

MACHINE_FEATURES += "pci"
MACHINE_EXTRA_RRECOMMENDS += "\
    linux-firmware-rpidistro-bcm43455 \
    bluez-firmware-rpidistro-bcm4345c0-hcd \
    linux-firmware-rpidistro-bcm43456 \
    bluez-firmware-rpidistro-bcm4345c5-hcd \
"

include conf/machine/include/rpi-base.inc

RPI_KERNEL_DEVICETREE = " \
    broadcom/bcm2711-rpi-4-b.dtb \
    broadcom/bcm2711-rpi-400.dtb \
    broadcom/bcm2711-rpi-cm4.dtb \
    broadcom/bcm2711-rpi-cm4s.dtb \
"

PREFERRED_PROVIDER_virtual/kernel = "linux-ov-rpi"

SERIAL_CONSOLES ?= "115200;ttyS0"

#Enable u-boot
RPI_USE_U_BOOT = "1"
ENABLE_UART = "1"
#Enable otg mode
ENABLE_DWC2_HOST = "1"

VC4DTBO ?= "vc4-kms-v3d"

# When u-boot is enabled we need to use the "Image" format and the "booti"
# command to load the kernel
KERNEL_IMAGETYPE_UBOOT ?= "Image"
# "zImage" not supported on arm64 and ".gz" images not supported by bootloader yet
KERNEL_IMAGETYPE_DIRECT ?= "Image"
KERNEL_BOOTCMD ?= "booti"

#ov-rpi-sdimg
IMAGE_CLASSES += "sdcard_image-ov-rpi"
IMAGE_FSTYPES = "tar.bz2 ext3 wic.bz2 wic.bmap ov-rpi-sdimg"

LICENSE_FLAGS_ACCEPTED = "synaptics-killswitch"