FILESEXTRAPATHS:prepend:ovlinux := "${THISDIR}/files:"

SPLASH_IMAGES = "file://psplash-ovlinux-img.h;outsuffix=default"
SPLASH_IMAGES:rpi = "file://psplash-ovlinux-img.h;outsuffix=default"

SRC_URI += "file://psplash-rotation \
            file://psplash-start.service \
            file://psplash-stop"

do_install:append() {
  install -d ${D}/opt/bin
  install -m 0755 ${WORKDIR}/psplash-rotation ${D}/opt/bin/psplash-rotation
  install -m 0755 ${WORKDIR}/psplash-stop ${D}/opt/bin/psplash-stop
}

FILES:${PN} += "/opt"
