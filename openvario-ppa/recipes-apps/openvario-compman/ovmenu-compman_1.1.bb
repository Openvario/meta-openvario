SUMMARY = "Compman main menu item"
HOMEPAGE = "https://github.com/kedder/openvario-compman"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"
RECIPE_MAINTAINER = "Andrey Lebedev <andrey.lebedev@gmail.com>"

S = "${WORKDIR}"
RDEPENDS:${PN} = "ovmenu-ng"

SRC_URI = "\
    file://ovmenu.patch.txt \
"
FILES:${PN} = " \
    /var/lib/misc/ovmenu.patch \
"

addtask do_package_write_ipk after do_package

do_compile() {
        :
}

do_install() {
        echo "Installing ..."
        install -d ${D}/var/lib/misc/
        install -m 0755 ${S}/ovmenu.patch.txt ${D}/var/lib/misc/ovmenu.patch
}

pkg_postinst_${PN}() {
#!/bin/sh
patch -p0 < /var/lib/misc/ovmenu.patch
}

pkg_prerm_${PN}() {
#!/bin/sh
patch --reverse -p0 < /var/lib/misc/ovmenu.patch
}
