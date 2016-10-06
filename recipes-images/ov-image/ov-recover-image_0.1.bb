SUMMARY = "Distribution of boot up and recovery itb's with kernel and boot up initramfs built in"
HOMEPAGE = "none"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r1"

S = "${WORKDIR}/${PN}-${PV}"

SRC_URI = "\
       	file://ov-recovery.its \
        "

DEPENDS = "\
        dtc \
        ov-recover-initramfs \
	"

do_compile[deptask] = "do_rm_work"

do_compile () {
	cp ${WORKDIR}/ov-recovery.its ${S}/ov-recovery.its
	#cp -v ${WORKDIR}/zImage.bin ${S}/zImage.bin
	cp -v ${DEPLOY_DIR_IMAGE}/uImage-${MACHINE}.bin ${S}/uImage-recovery.bin
	cp -v ${DEPLOY_DIR_IMAGE}/ov-base-initramfs-${MACHINE}.cpio.gz ${S}/initramfs.cpio.gz
	cp -v ${DEPLOY_DIR_IMAGE}/uImage-openvario.dtb ${S}/openvario.dtb
	#cp -v ${DEPLOY_DIR_IMAGE}/fex.bin ${S}/script.bin
	
	#if [ ! -e "${S}/zImage-${MACHINE}.bin" ]; then bbfatal "missing uIUmage-${MACHINE}.bin !"; fi
	#if [ ! -e "${S}/magna-initramfs-${MACHINE}.cpio.gz" ]; then bbfatal "missing magna-initramfs-${MACHINE}.cpio.gz !"; fi
	
	dd if=${S}/uImage-recovery.bin of=${S}/zImage-recovery skip=64 iflag=skip_bytes
}

do_mkimage () {
	mkimage -A arm -f ov-recovery.its ov-recovery.itb
} 

addtask mkimage after do_compile before do_install

do_install () {
	cp ${WORKDIR}/${PN}-${PV}/ov-recovery.itb ${DEPLOY_DIR_IMAGE}
}
