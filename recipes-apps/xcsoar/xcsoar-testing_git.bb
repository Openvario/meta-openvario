# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "XCSoar glide computer"
HOMEPAGE = "www.xcsoar.org"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=393a5ca445f6965873eca0259a17f833"
SECTION = "base/app"
PR = "r13"
RCONFLICTS_${PN}="xcsoar"

DEPENDS = "	\
		gcc \
		boost \
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

LC_LOCALE_PATH = "/usr/share/locale"

SRCREV_pn-xcsoar-testing = "${AUTOREV}" 

SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=git;branch=master \
           file://ov-xcsoar.conf"

SRC_URI_append = " file://0001-avoid-tail-cut.patch"
SRC_URI_append = " file://0005-Adapted-toolchain-prefixes-for-cross-compile.patch"
SRC_URI_append = " file://0007-Disable-touch-screen-auto-detection.patch"

inherit pkgconfig update-alternatives

addtask do_package_write_ipk after do_package

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
	make -j$(nproc) DEBUG=n DEBUG_GLIBCXX=n ENABLE_MESA_KMS=y GLES2=y GEOTIFF=n
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

	install -d ${D}${LC_LOCALE_PATH}/de/LC_MESSAGES
	install -m 0755 ${S}/output/po/de.mo ${D}${LC_LOCALE_PATH}/de/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/cs/LC_MESSAGES
	install -m 0755 ${S}/output/po/cs.mo ${D}${LC_LOCALE_PATH}/cs/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/da/LC_MESSAGES
	install -m 0755 ${S}/output/po/da.mo ${D}${LC_LOCALE_PATH}/da/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/el/LC_MESSAGES
	install -m 0755 ${S}/output/po/el.mo ${D}${LC_LOCALE_PATH}/el/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/es/LC_MESSAGES
	install -m 0755 ${S}/output/po/es.mo ${D}${LC_LOCALE_PATH}/es/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/fr/LC_MESSAGES
	install -m 0755 ${S}/output/po/fr.mo ${D}${LC_LOCALE_PATH}/fr/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/he/LC_MESSAGES
	install -m 0755 ${S}/output/po/he.mo ${D}${LC_LOCALE_PATH}/he/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/hr/LC_MESSAGES
	install -m 0755 ${S}/output/po/hr.mo ${D}${LC_LOCALE_PATH}/hr/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/hu/LC_MESSAGES
	install -m 0755 ${S}/output/po/hu.mo ${D}${LC_LOCALE_PATH}/hu/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/it/LC_MESSAGES
	install -m 0755 ${S}/output/po/it.mo ${D}${LC_LOCALE_PATH}/it/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/ja/LC_MESSAGES
	install -m 0755 ${S}/output/po/ja.mo ${D}${LC_LOCALE_PATH}/ja/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/ko/LC_MESSAGES
	install -m 0755 ${S}/output/po/ko.mo ${D}${LC_LOCALE_PATH}/ko/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/lt/LC_MESSAGES
	install -m 0755 ${S}/output/po/lt.mo ${D}${LC_LOCALE_PATH}/lt/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/nb/LC_MESSAGES
	install -m 0755 ${S}/output/po/nb.mo ${D}${LC_LOCALE_PATH}/nb/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/nl/LC_MESSAGES
	install -m 0755 ${S}/output/po/nl.mo ${D}${LC_LOCALE_PATH}/nl/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/pl/LC_MESSAGES
	install -m 0755 ${S}/output/po/pl.mo ${D}${LC_LOCALE_PATH}/pl/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/pt/LC_MESSAGES
	install -m 0755 ${S}/output/po/pt.mo ${D}${LC_LOCALE_PATH}/pt/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/ro/LC_MESSAGES
	install -m 0755 ${S}/output/po/ro.mo ${D}${LC_LOCALE_PATH}/ro/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/ru/LC_MESSAGES
	install -m 0755 ${S}/output/po/ru.mo ${D}${LC_LOCALE_PATH}/ru/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/sk/LC_MESSAGES
	install -m 0755 ${S}/output/po/sk.mo ${D}${LC_LOCALE_PATH}/sk/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/sl/LC_MESSAGES
	install -m 0755 ${S}/output/po/sl.mo ${D}${LC_LOCALE_PATH}/sl/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/sr/LC_MESSAGES
	install -m 0755 ${S}/output/po/sr.mo ${D}${LC_LOCALE_PATH}/sr/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/sv/LC_MESSAGES
	install -m 0755 ${S}/output/po/sv.mo ${D}${LC_LOCALE_PATH}/sv/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/tr/LC_MESSAGES
	install -m 0755 ${S}/output/po/tr.mo ${D}${LC_LOCALE_PATH}/tr/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/uk/LC_MESSAGES
	install -m 0755 ${S}/output/po/uk.mo ${D}${LC_LOCALE_PATH}/uk/LC_MESSAGES/xcsoar.mo
	install -d ${D}${LC_LOCALE_PATH}/vi/LC_MESSAGES
	install -m 0755 ${S}/output/po/vi.mo ${D}${LC_LOCALE_PATH}/vi/LC_MESSAGES/xcsoar.mo
}

FILES_${PN} = " \
	/opt/XCSoar/bin/xcsoar \
	/opt/XCSoar/bin/vali-xcs \
	/opt/conf/default/ov-xcsoar.conf \
	/opt/conf/ov-xcsoar.conf \
	${LC_LOCALE_PATH}/de/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/cs/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/da/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/el/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/es/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/fr/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/he/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/hr/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/hu/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/it/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/ja/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/ko/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/lt/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/nb/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/nl/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/pl/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/pt/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/ro/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/ru/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/sk/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/sl/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/sr/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/sv/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/tr/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/uk/LC_MESSAGES/xcsoar.mo \
	${LC_LOCALE_PATH}/vi/LC_MESSAGES/xcsoar.mo \
"

