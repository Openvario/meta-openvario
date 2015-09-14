#Angstrom image to test systemd

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

IMAGE_PREPROCESS_COMMAND = "rootfs_update_timestamp ;"

DISTRO_UPDATE_ALTERNATIVES ??= ""
ROOTFS_PKGMANAGE_PKGS ?= '${@base_conditional("ONLINE_PACKAGE_MANAGEMENT", "none", "", "${ROOTFS_PKGMANAGE} ${DISTRO_UPDATE_ALTERNATIVES}", d)}'

CONMANPKGS ?= "connman connman-client connman-angstrom-settings connman-plugin-loopback connman-plugin-ethernet connman-plugin-wifi connman-systemd"
CONMANPKGS_libc-uclibc = ""

IMAGE_INSTALL += "\
	packagegroup-base-extended \
	angstrom-packagegroup-boot \
        packagegroup-basic \
        ${CONMANPKGS} \
        ${ROOTFS_PKGMANAGE_PKGS} \
        timestamp-service \
	systemd-vconsole-setup \
        sunxi-mali \
        xcsoar \
        ttf-dejavu-common \
        ttf-dejavu-sans-condensed \
        ttf-dejavu-sans-mono \
        ttf-dejavu-sans \
        ttf-dejavu-serif-condensed \
        ttf-dejavu-serif \
        sensord \
        openvario-modules-autoload \
        openvario-autologin \
	ovmenu-ng \
        ovmenu-ng-skripts \
	ovmenu-ng-autostart \
        ov-tools \
	varioapp \
        bash \
        vim \
        nano \
        e2fsprogs \
        autofs \
        connman-ncurses \
        linux-firmware-ralink \
"

IMAGE_DEV_MANAGER   = "udev"
IMAGE_INIT_MANAGER  = "systemd"
IMAGE_INITSCRIPTS   = " "
IMAGE_LOGIN_MANAGER = "busybox shadow"

export IMAGE_BASENAME = "systemd-image"

inherit image
