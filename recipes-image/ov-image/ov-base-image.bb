SUMMARY = "OpenVario Flight Computer Core Image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

CONMANPKGS ?= "connman connman-client connman-plugin-loopback connman-plugin-ethernet connman-plugin-wifi"
CONMANPKGS_libc-uclibc = ""

IMAGE_INSTALL += "\
	packagegroup-core-boot \
	${ROOTFS_PKGMANAGE_BOOTSTRAP} \
	${CONMANPKGS} \
	distro-feed-configs \
	opkg \
	bash \
	openssh \
	vim \
	nano \
	e2fsprogs \
	"


export IMAGE_BASENAME = "ov-base-image"

inherit image
