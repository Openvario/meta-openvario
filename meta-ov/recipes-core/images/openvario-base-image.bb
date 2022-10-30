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
    linux-firmware-rtl8192 \
    linux-firmware-rtl8712 \
    linux-firmware-rtl8723 \
    linux-firmware-rtl8821 \
"

LOCALE_PACKAGES = " \
    locale-base-en-us \
    locale-base-de-de \
    locale-base-es-es \
    locale-base-fr-fr \
    locale-base-it-it \
    locale-base-hu-hu \
    locale-base-pl-pl \
    locale-base-cs-cz \
    locale-base-sk-sk \
    locale-base-ru-ru \
    locale-base-lt-lt \
"

IMAGE_INSTALL = " \
    packagegroup-base \
    distro-feed-configs \
    nano \
    openssh-sftp-server \
    tslib \
    tslib-tests \
    tslib-uinput \
    tslib-conf \
    tslib-calibrate \
    touch-udev-rules \
    ts-uinput-service \
    ${COMMON_WIFI_FIRMWARE_PACKAGES} \
    ${LOCALE_PACKAGES} \
    fix-cpu-freq\
"

#                    packagegroup-base packagegroup-core-ssh-openssh 

#${CORE_IMAGE_EXTRA_INSTALL} 

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image extrausers

#IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE:append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

# Add root to audio group to allow root to use pulseaudio server
EXTRA_USERS_PARAMS = "\
    usermod -a -G audio root; \
"

# These systemd units are going to be masked, because they are a no-op
# and just waste boot time.
MASK_SYSTEMD_UNITS = " \
	dev-hugepages.mount \
	dev-mqueue.mount \
	sys-fs-fuse-connections.mount \
	sys-kernel-config.mount \
	sys-kernel-debug.mount \
	sys-kernel-tracing.mount \
	modprobe@.service \
	systemd-sysctl.service \
"

mask_systemd_units() {
	for i in ${MASK_SYSTEMD_UNITS}; do
		ln -s /dev/null ${IMAGE_ROOTFS}${sysconfdir}/systemd/system/$i
	done
}

ROOTFS_POSTPROCESS_COMMAND += "mask_systemd_units;"

delete_uimage() {
	# delete the redundant kernel image from the root partition; another
	# copy is on the /boot partition, and that one is used by
	# u-boot
	rm -f ${IMAGE_ROOTFS}/boot/*Image*
}

ROOTFS_POSTINSTALL_COMMAND += "delete_uimage;"
