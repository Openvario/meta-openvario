# Openvario Linux base initramfs image 
inherit image

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

IMAGE_FEATURES += "package-management"

INITRAMFS_FILES_prepend := "${THISDIR}/initramfs/"

IMAGE_INSTALL = ""
DEPENDS += " \
		busybox \
		e2fsprogs \
		vim \
		ncurses \
		pv \
		ovmenu-recovery \
		bash \
		udev \
		cfgmgr \
		"

PACKAGE_INSTALL = " \
		busybox \
		e2fsprogs-e2fsck \
		e2fsprogs-mke2fs \
		ncurses \
		pv \
		vim \
		ovmenu-recovery \
		bash \
		udev \
		cfgmgr \
		"

IMAGE_DEV_MANAGER   = "udev"
IMAGE_INIT_MANAGER  = "systemd"
IMAGE_INITSCRIPTS   = " "
IMAGE_FSTYPES = "cpio.gz"

ROOTFS_POSTPROCESS_COMMAND += "magna_initramfs_generate_init ; "

fakeroot magna_initramfs_generate_init () {
	install -m 0755 ${INITRAMFS_FILES}/init.head ${IMAGE_ROOTFS}/init
	install -m 0755 ${INITRAMFS_FILES}/reboot.sh ${IMAGE_ROOTFS}/opt/bin/reboot.sh

	chmod 0755 ${IMAGE_ROOTFS}/init
}

export IMAGE_BASENAME = "ov-base-initramfs"
