DESCRIPTION = "XCSoar glide computer"
HOMEPAGE = "www.xcsoar.org"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=393a5ca445f6965873eca0259a17f833"
SECTION = "base/app"

DEPENDS = "	\
		curl \
		pkgconfig \
		libxslt-native \
		librsvg-native \
		imagemagick-native \
		libinput \
		lua \
		udev \
		ttf-dejavu \
		jpeg \
		freetype \
		libpng \
		glm \
		virtual/egl \
		virtual/mesa \
		virtual/libgles1 \
		virtual/libgles2 \
		alsa-lib \
		libsodium \
		c-ares \
"

RDEPENDS_${PN} = "\
        ttf-dejavu-sans-condensed \
"

S = "${WORKDIR}/git"

LC_LOCALE_PATH = "${datadir}/locale"

SRC_URI_append = " file://0001-avoid-tail-cut.patch"
SRC_URI_append = " file://0007-Disable-touch-screen-auto-detection.patch"
SRC_URI_append = " file://0001-HasNoPointer.patch"

inherit pkgconfig

addtask do_package_write_ipk after do_package

EXTRA_OEMAKE = " \
	HOSTCC='${BUILD_CC}' \
	HOSTCXX='${BUILD_CXX}' \
	AR='${AR}' \
	RANLIB='${RANLIB}' \
	CXX='${CXX}' \
	CC='${CC}' \
	AS='${AS}' \
	LD='${LD}' \
	STRIP='${STRIP}' \
	CCACHE='' \
	\
	DEBUG=n DEBUG_GLIBCXX=n \
	ENABLE_MESA_KMS=y GLES2=y \
	GEOTIFF=n \
"

do_compile() {
	echo $CC
	$CC --version
	echo "Create missing symlinks ..."
	echo '${STAGING_DIR_TARGET}'
	echo '${PATH}'
	export PATH=$PATH:/usr/bin
	echo '${PATH}'
	#ln -s ${STAGING_DIR_TARGET}/usr/bin/convert.im7 ${STAGING_DIR_TARGET}/usr/bin/convert
	export FONTCONFIG_PATH=/etc/fonts
	echo "Making .."
	echo '${WORKDIR}'
	cd ${WORKDIR}/git
	oe_runmake
}

do_install() {
	echo "Installing ..."
	install -d ${D}/opt/XCSoar/bin
	install -m 0755 ${S}/output/UNIX/bin/xcsoar ${D}/opt/XCSoar/bin
	install -m 0755 ${S}/output/UNIX/bin/vali-xcs ${D}/opt/XCSoar/bin

	install -d ${D}/opt/conf
	install -d ${D}/opt/conf/default
	install -m 0755 ${S}/../ov-xcsoar.conf ${D}/opt/conf/default/ov-xcsoar.conf
	install -m 0755 ${S}/../ov-xcsoar.conf ${D}/opt/conf/ov-xcsoar.conf

	oe_runmake install-mo DESTDIR=${D}
}

FILES_${PN} = " \
	/opt/XCSoar/bin/xcsoar \
	/opt/XCSoar/bin/vali-xcs \
	/opt/conf/default/ov-xcsoar.conf \
	/opt/conf/ov-xcsoar.conf \
	${LC_LOCALE_PATH}/*/LC_MESSAGES/xcsoar.mo \
"
