PREFERRED_PROVIDER_virtual/xserver = "xserver-xorg"
XSERVER = "xserver-xorg \
           xf86-video-fbturbo \
           xf86-input-evdev \
           xf86-input-mouse \
           xf86-input-keyboard"

PREFERRED_PROVIDER_virtual/kernel = "linux"
PREFERRED_VERSION_linux-sunxi ?= "3.4.%"
PREFERRED_VERSION_linux-libc-headers = "3.4.61"

KERNEL_IMAGETYPE = "uImage"

IMAGE_CLASSES += "sdcard_image-sunxi"
IMAGE_FSTYPES += "ext3 tar.gz sunxi-sdimg"

MACHINE_EXTRA_RRECOMMENDS = "kernel-modules"

UBOOT_LOCALVERSION = "-g${@d.getVar('SRCPV', True).partition('+')[2][0:7]}"