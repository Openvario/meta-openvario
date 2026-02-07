SUMMARY = "Distribution of boot up and recovery itb's with kernel and boot up initramfs built in"
HOMEPAGE = "none"
LICENSE = "MIT"
# openvario-base-image.bb is without CheckSum:
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

require ov-revision.inc

S = "${WORKDIR}/${PN}-${PV}"

SRC_URI = "\
        file://openvario-recovery.its \
        "

DEPENDS = "\
        dtc-native \
        virtual/kernel \
        openvario-recovery-initramfs \
        u-boot-mkimage-native \
        u-boot \
    "

# DEPENDS += "ov-revision.inc "

do_compile[deptask] = "do_rm_work"

## the next line can be toggled between new and old!
do_configure () {
	cp ${WORKDIR}/openvario-recovery.its ${S}
	#new image
	dd if=${DEPLOY_DIR_IMAGE}/uImage of=${S}/Image bs=64 skip=1
	# new initramfs (TBR: added rootfs into name)
	cp -v ${DEPLOY_DIR_IMAGE}/openvario-base-initramfs-${MACHINE}.rootfs.cpio.gz ${S}/initramfs.cpio.gz
        cp -v ${DEPLOY_DIR_IMAGE}/${MACHINE}.dtb ${S}/openvario.dtb
}

# do_compile () {
#     pwd  # only as WO for one action
# }

do_mkimage () {
    # show mkimage version:
    MK_IMAGE=mkimage
    $MK_IMAGE -V
    # Build ITB with provided config
    $MK_IMAGE -A arm -f ${S}/openvario-recovery.its ${S}/ov-recovery.itb
}

addtask mkimage after do_configure before do_install

do_install () {
    cp ${S}/ov-recovery.itb ${DEPLOY_DIR_IMAGE}
}
