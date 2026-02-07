SUMMARY = "A small image just capable of allowing a device to boot."
inherit core-image

LICENSE = "MIT"

require ov-revision.inc

IMAGE_FEATURES += " package-management"

INITRAMFS_FILES:prepend := "${THISDIR}/initramfs/"

# Remove all installed packages to get a really small initramfs
IMAGE_INSTALL = ""

DEPENDS += " \
		busybox \
		e2fsprogs \
		ncurses \
		pv \
		ovmenu-recovery \
		bash \
		udev \
		"

PACKAGE_INSTALL = " \
		busybox \
		e2fsprogs-e2fsck \
		e2fsprogs-mke2fs \
		ncurses \
		pv \
		ovmenu-recovery \
		bash \
		udev \
		"

IMAGE_DEV_MANAGER   = "udev"
IMAGE_INIT_MANAGER  = "systemd"
IMAGE_INITSCRIPTS   = " "
IMAGE_FSTYPES = "cpio.gz"

ROOTFS_POSTPROCESS_COMMAND += "openvario_initramfs_generate_init ; "

fakeroot openvario_initramfs_generate_init () {
	install -m 0755 ${INITRAMFS_FILES}/init.head ${IMAGE_ROOTFS}/init
	install -m 0755 ${INITRAMFS_FILES}/reboot.sh ${IMAGE_ROOTFS}/opt/bin/reboot.sh

	chmod 0755 ${IMAGE_ROOTFS}/init
}

export IMAGE_BASENAME = "openvario-base-initramfs"
