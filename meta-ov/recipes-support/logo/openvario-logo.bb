SUMMARY = "The OpenVario logo"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"

inherit allarch

DEPENDS = " \
	librsvg-native \
	imagemagick-native \
	ttf-dejavu \
	bc-native \
"

RSVG_CONVERT = "rsvg-convert"
CONVERT = "convert.im7"
BACKGROUND_COLOR = "rgb(255,255,255)"
LOGO_FILE = "openvario-black.svg"
FONT = "${RECIPE_SYSROOT}/${datadir}/fonts/truetype/DejaVuSans.ttf"
BOOT_TEXT = "Starting..."
RECOVER_TEXT = "!!! Recovery !!!"

SRC_URI = "\
	file://${LOGO_FILE} \
"

# build_uboot_logos1 PREFIX WIDTH HEIGHT TEXT
build_uboot_logos1() {
	_PREFIX="$1"
	_WIDTH="$2"
	_HEIGHT="$3"
	_TEXT="$4"

	_SIZE="$_WIDTH"x"$_HEIGHT"
	_PORTRAIT_SIZE="$_HEIGHT"x"$_WIDTH"

	_LOGO_POSITION_LANDSCAPE=$(echo "$_HEIGHT / -4" | bc)
	_LOGO_POSITION_PORTRAIT=$(echo "$_HEIGHT / -12" | bc)

	_FONTSIZE=$(echo "$_HEIGHT / 13" | bc)
	_TEXT_POSITION=$(echo "$_HEIGHT / 12" | bc)

	${CONVERT} -size $_SIZE "xc:${BACKGROUND_COLOR}" \
		   -gravity Center \
		   -draw "image over 0,$_LOGO_POSITION_PORTRAIT 0,0 '${B}/$_SIZE/landscape.png'" \
		   -gravity South \
		   -font "${FONT}" -pointsize $_FONTSIZE -draw "text 0,$_TEXT_POSITION '$_TEXT'" \
		   -alpha off \
		   -type Palette \
		   ${B}/$_SIZE/"$_PREFIX"_0.bmp
	${CONVERT} -rotate 180 ${B}/$_SIZE/"$_PREFIX"_0.bmp ${B}/$_SIZE/"$_PREFIX"_2.bmp

	${CONVERT} -size $_PORTRAIT_SIZE "xc:${BACKGROUND_COLOR}" \
		   -gravity Center \
		   -draw "image over 0,$_LOGO_POSITION_LANDSCAPE 0,0 '${B}/$_SIZE/portrait.png'" \
		   -gravity South \
		   -font "${FONT}" -pointsize $_FONTSIZE -draw "text 0,$_TEXT_POSITION '$_TEXT'" \
		   -alpha off \
		   -type Palette \
		   ${B}/$_SIZE/"$_PREFIX"_portrait.bmp
	${CONVERT} -rotate 90 ${B}/$_SIZE/"$_PREFIX"_portrait.bmp ${B}/$_SIZE/"$_PREFIX"_1.bmp
	${CONVERT} -rotate 270 ${B}/$_SIZE/"$_PREFIX"_portrait.bmp ${B}/$_SIZE/"$_PREFIX"_3.bmp
}

# build_uboot_logos2 WIDTH HEIGHT
build_uboot_logos2() {
	_WIDTH="$1"
	_HEIGHT="$2"

	_SIZE="$_WIDTH"x"$_HEIGHT"

	install -d ${B}/$_SIZE

	_LANDSCAPE_HEIGHT=$(echo "$_HEIGHT * 2 / 3" | bc)
	_PORTRAIT_WIDTH=$(echo "$_HEIGHT * 9 / 10" | bc)

	${RSVG_CONVERT} -h $_LANDSCAPE_HEIGHT -o ${B}/$_SIZE/landscape.png "${WORKDIR}/${LOGO_FILE}"
	${RSVG_CONVERT} -w $_PORTRAIT_WIDTH -o ${B}/$_SIZE/portrait.png "${WORKDIR}/${LOGO_FILE}"

	build_uboot_logos1 ov_booting $_WIDTH $_HEIGHT "${BOOT_TEXT}"
	build_uboot_logos1 ov_recover $_WIDTH $_HEIGHT "${RECOVER_TEXT}"
}

do_compile() {
	build_uboot_logos2 1280 800
	build_uboot_logos2 1024 600
	build_uboot_logos2 800 480
	build_uboot_logos2 640 480
	build_uboot_logos2 480 272
}

do_compile[depends] += "ttf-dejavu:do_populate_sysroot"

do_install() {
	for i in 1280x800 1024x600 800x480 640x480 480x272; do
		install -d ${D}/${datadir}/openvario/u-boot/$i
		install ${B}/$i/ov_*_?.bmp ${D}/${datadir}/openvario/u-boot/$i
	done
}

FILES:${PN} += " \
	${datadir}/openvario/u-boot/*/*.bmp \
"
