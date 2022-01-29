DESCRIPTION = "Linux Console Fonts from The ZAP Group"
HOMEPAGE = "https://www.zap.org.au/projects/console-fonts-zap/"
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://console-fonts-zap-${PV}/COPYING;md5=9f3db23d68a7af0ba451e9dbbbb8f04e"

S = "${WORKDIR}"

SRC_URI = "https://ftp.zap.org.au/pub/fonts/console-fonts-zap/console-fonts-zap-2.3.tar.xz"
SRC_URI[sha256sum] = "b03cd67957649444f877679d77aadb1f4757e0fdc764e58ba01dbe37a3855cec"

inherit allarch

do_compile() {
        :
}

do_install() {
        install -d ${D}/usr/share/consolefonts/
        install -m 0644 ${S}/console-fonts-zap-${PV}/*.psf ${D}/usr/share/consolefonts/
}

FILES_${PN} = "/usr/share/consolefonts/"
