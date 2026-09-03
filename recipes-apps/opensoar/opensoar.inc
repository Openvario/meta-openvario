DESCRIPTION = "OpenSoar glide computer"
HOMEPAGE = "www.opensoar.de"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=393a5ca445f6965873eca0259a17f833"
SECTION = "base/app"

DEPENDS = "	\
		curl \
		pkgconfig-native \
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
		tiff \
		libgeotiff \
		glm \
		virtual/egl \
		virtual/mesa \
		virtual/libgles2 \
		alsa-lib \
		libsodium \
		c-ares \
		fmt \
		dbus \
		wpa-supplicant \
"

RDEPENDS:${PN} = "\
        ttf-dejavu-sans-condensed \
        variod \
"

S = "${WORKDIR}/git"

LC_LOCALE_PATH = "${datadir}/locale"

# Keep .mo locale files in the main package instead of splitting into opensoar-locale-* sub-packages
PACKAGE_NO_LOCALE = "1"
PACKAGES:remove = "${PN}-locale"

NETCDF_URL ?= "https://storage.googleapis.com/lazyrasp.com/xcsoar/netcdf-c-4.6.2.tar.gz"
NETCDF_HASH ?= "eda1be377fce86e5d91b30a00b15bb7ea9c97f5c5ef007901145549786781710"
NETCDF_CXX_URL ?= "https://storage.googleapis.com/lazyrasp.com/xcsoar/netcdf-cxx-4.2.tar.gz"
NETCDF_CXX_HASH ?= "95ed6ab49a0ee001255eac4e44aacb5ca4ea96ba850c08337a3e4c9a0872ccd1"

BOOST_URL = "https://archives.boost.io/release/${BOOST_VERSION}/source/${BOOST_FILE}"
BOOST_HASH = "${BOOST_SHA256HASH}"
BOOST_FILE = "boost_${@'${BOOST_VERSION}'.replace('.','_')}.tar.bz2"
SRC_URI += " \
	file://0007-Disable-touch-screen-auto-detection.patch \
	${BOOST_URL};sha256sum=${BOOST_HASH};unpack=0 \
	${NETCDF_URL};sha256sum=${NETCDF_HASH};unpack=0 \
	${NETCDF_CXX_URL};sha256sum=${NETCDF_CXX_HASH};unpack=0 \
"

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
	TARGET=OPENVARIO_CB2 \
	DEBUG=n DEBUG_GLIBCXX=n \
	ENABLE_MESA_KMS=y GLES2=y \
	GEOTIFF=y \
"

do_configure() {
	install -d ${B}/output/download
	cp ${WORKDIR}/${BOOST_FILE} ${B}/output/download/
	oe_runmake boost
}

do_compile() {
	export PATH=$PATH:/usr/bin
	ln -sf convert.im7 ${STAGING_DIR_NATIVE}/usr/bin/convert
	export FONTCONFIG_PATH=/etc/fonts
	oe_runmake
	# oe_runmake output/OPENVARIO/bin/OpenVarioBaseMenu
	# oe_runmake output/UNIX/bin/OpenVarioBaseMenu
}

do_install() {
	oe_runmake install-bin install-mo DESTDIR=${D}
	# install -m755 ${S}/output/OPENVARIO/bin/OpenVarioBaseMenu ${D}${bindir}
	# install -m755 ${S}/output/UNIX/bin/OpenVarioBaseMenu ${D}${bindir}

	# Has to be removed, because this is in xcsoar-package. Otherwise causes QA error.
	rm -f ${D}${bindir}/vali-xcs
}

FILES:${PN} = " \
	${bindir}/OpenSoar \
	${LC_LOCALE_PATH}/*/LC_MESSAGES/opensoar.mo \
"

# ${bindir}/OpenVarioBaseMenu 
# this is in xcsoar-package:	${bindir}/vali-xcs 

