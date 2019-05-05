SUMMARY = "A small image just capable of allowing a device to boot."

IMAGE_FEATURES += "splash ssh-server-dropbear package-management"

IMAGE_INSTALL =     "packagegroup-base \
                    xcsoar-testing-fb \
                    "

#                    packagegroup-base packagegroup-core-ssh-openssh 

#${CORE_IMAGE_EXTRA_INSTALL} 

IMAGE_LINGUAS = " "

LICENSE = "MIT"

#DISTRO_FEATURES += "directfb"

inherit core-image

#IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_SIZE ?= "3768320"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"