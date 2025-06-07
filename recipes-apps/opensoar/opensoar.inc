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
		tiff \
"
DEPENDS_RESERVE = " \
		sqlite3 \
		proj \
		\
		libtiff \
		libgeotiff \
		netcdf \
		netcdf_c++ \
"

RDEPENDS:${PN} = "\
        ttf-dejavu-sans-condensed \
"

S = "${WORKDIR}/git"

LC_LOCALE_PATH = "${datadir}/locale"

# LIBTIFF_URL = "http://download.osgeo.org/libtiff/tiff-4.6.0.tar.xz"
# LIBTIFF_HASH="e178649607d1e22b51cf361dd20a3753f244f022eefab1f2f218fc62ebaf87d2"
# PROJ_URL = "http://download.osgeo.org/proj/proj-9.3.1.tar.gz"
# PROJ_HASH="b0f919cb9e1f42f803a3e616c2b63a78e4d81ecfaed80978d570d3a5e29d10bc"
# SQLITE_URL = "https://www.sqlite.org/2023/sqlite-autoconf-3420000.tar.gz"
# SQLITE_HASH="7abcfd161c6e2742ca5c6c0895d1f853c940f203304a0b49da4e1eca5d088ca6"
NETCDF_URL = "https://storage.googleapis.com/lazyrasp.com/xcsoar/netcdf-c-4.6.2.tar.gz"
NETCDF_HASH="eda1be377fce86e5d91b30a00b15bb7ea9c97f5c5ef007901145549786781710"
NETCDF_CXX_URL = "https://storage.googleapis.com/lazyrasp.com/xcsoar/netcdf-cxx-4.2.tar.gz"
NETCDF_CXX_HASH="95ed6ab49a0ee001255eac4e44aacb5ca4ea96ba850c08337a3e4c9a0872ccd1"
GEOTIFF_URL = "http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.7.1.tar.gz"
GEOTIFF_HASH="05ab1347aaa471fc97347d8d4269ff0c00f30fa666d956baba37948ec87e55d6"

BOOST_URL = "https://archives.boost.io/release/${BOOST_VERSION}/source/${BOOST_FILE}"
BOOST_HASH = "${BOOST_SHA256HASH}"
BOOST_FILE = "boost_${@'${BOOST_VERSION}'.replace('.','_')}.tar.bz2"
SRC_URI += " \
	file://0007-Disable-touch-screen-auto-detection.patch \
	${BOOST_URL};sha256sum=${BOOST_HASH};unpack=0 \
	${NETCDF_URL};sha256sum=${NETCDF_HASH};unpack=0 \
	${NETCDF_CXX_URL};sha256sum=${NETCDF_CXX_HASH};unpack=0 \
"
# SRC_URI += " ${SQLITE_URL};sha256sum=${SQLITE_HASH};unpack=0 "
# SRC_URI += " ${LIBTIFF_URL};sha256sum=${LIBTIFF_HASH};unpack=0 "
# SRC_URI += " ${PROJ_URL};sha256sum=${PROJ_HASH};unpack=0 \
# SRC_URI += " ${GEOTIFF_URL};sha256sum=${GEOTIFF_HASH};unpack=0 "


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
}

FILES:${PN} = " \
	${bindir}/OpenSoar \
	${LC_LOCALE_PATH}/*/LC_MESSAGES/opensoar.mo \
"

# ${bindir}/OpenVarioBaseMenu 
# this is in xcsoar-package:	${bindir}/vali-xcs 

