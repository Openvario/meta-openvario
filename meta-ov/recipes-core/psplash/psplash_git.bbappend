FILESEXTRAPATHS:prepend:ovlinux := "${THISDIR}/files:"

SPLASH_IMAGES = "file://psplash-ovlinux-img.h;outsuffix=default"

SRC_URI += "file://psplash-rotation \
            file://psplash-start.service"

do_install_append() {
  install -d ${D}/opt/bin
  install -m 0755 ${WORKDIR}/psplash-rotation ${D}/opt/bin/psplash-rotation
}

FILES_${PN} += "/opt"
