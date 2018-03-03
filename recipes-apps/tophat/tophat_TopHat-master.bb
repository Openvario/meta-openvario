# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "TopHat glide computer"
HOMEPAGE = "www.tophatsoaring.org"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=801f80980d171dd6425610833a22dbe6"
SECTION = "base/app"
DEPENDS = "	libsdl \
		jpeg \
		freetype \
		libpng \
		libinput \
		boost \
		ttf-dejavu \
		sunxi-mali \
		curlpp \
"

RDEPENDS_${PN} = "	sunxi-mali \
			libinput \
			libsdl \
			udev \
"

S = "${WORKDIR}/git"
PR = "r1"
LC_LOCALE_PATH = "/usr/share/locale"

SRCREV_pn-tophat = "${AUTOREV}"
SRC_URI = 	"git://github.com/rdunning0823/tophat.git;protocol=https;branch=TopHat_master \
				 file://0001-Adapted-Flags-for-compiler-and-linker-for-cross-comp.patch \
				 file://0003-Adapted-toolchain-prefixes-for-cross-compile.patch \
				 file://0001-Disable-warnings-as-errors.patch \
				 file://0001-Override-detection-of-target-hardware.patch \
				 file://0001-Workaround-for-Shutdown-bug.patch \
				 file://0001-Increase-refresh-intervall.patch \
				 file://no_libpulse.patch \
				 file://001_alway_parse_resolution.patch \
"

addtask do_package_write_ipk after do_package after do_install

do_compile() {
	echo $CC
	$CC --version
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git
	make -j8 DEBUG=n DEBUG_GLIBCXX=n USE_LIBINPUT=y
}

do_install() {
	echo "Installing ..."
	install -d ${D}/opt/tophat/bin
	install -m 0755 ${S}/output/UNIX/bin/* ${D}/opt/tophat/bin
	rm -rf ${D}/opt/tophat/bin/.debug
}

FILES_${PN} = " \
	/opt/tophat/bin/* \
"

