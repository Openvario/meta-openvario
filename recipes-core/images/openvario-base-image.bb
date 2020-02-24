SUMMARY = "A small image just capable of allowing a device to boot."

IMAGE_FEATURES += "splash ssh-server-dropbear package-management"
DEPENDS += "linux-firmware \
    "

# Include common WIFI firmware packages into the image. All linux-firmware
# packages take almost 500MB of space uncompressed, so we don't want to ship
# all of them with the image. Ship image with most used firmware instead and
# allow to download others with package manager
COMMON_WIFI_FIRMWARE_PACKAGES = " \
    linux-firmware-ralink \
    linux-firmware-rtl8168 \
    linux-firmware-rtl8188 \
    linux-firmware-rtl8192ce \
    linux-firmware-rtl8192cu \
    linux-firmware-rtl8192su \
    linux-firmware-rtl8723 \
    linux-firmware-rtl8821 \
"

IMAGE_INSTALL = " \
    packagegroup-base \
    ${COMMON_WIFI_FIRMWARE_PACKAGES} \
"

#                    packagegroup-base packagegroup-core-ssh-openssh 

#${CORE_IMAGE_EXTRA_INSTALL} 

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

#IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"