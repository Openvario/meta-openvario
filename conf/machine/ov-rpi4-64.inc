# Common machine definitions for all 64-bit Raspberry Pi4 / CM4 OpenVarios

require ov-raspberrypi4.inc
require conf/machine/include/arm/armv8a/tune-cortexa72.inc

KBUILD_DEFCONFIG:ov-rpi4-64 ?= "bcm2711_defconfig"

SDIMG_KERNELIMAGE ?= "kernel8.img"

UBOOT_MACHINE = "rpi_arm64_config"

ARMSTUB ?= "armstub8-gic.bin"
