FILESEXTRAPATHS:prepend:ovlinux := "${THISDIR}/files:"

SPLASH_IMAGES = "file://psplash-ovlinux-img.h;outsuffix=default"
SPLASH_IMAGES:rpi = "file://psplash-ovlinux-img.h;outsuffix=default"

# Draw the first status in psplash itself, before ov-system-init runs.
PACKAGECONFIG:append = " startup-msg"

SRC_URI += "file://psplash-rotation \
            file://psplash-start.service \
            file://psplash-stop \
            file://psplash-message \
            file://0001-openvario-startup-text.patch"

SRC_URI:append:rpi = " file://openvario-framebuf.conf"

do_install:append() {
  install -d ${D}/opt/bin
  install -m 0755 ${WORKDIR}/psplash-rotation ${D}/opt/bin/psplash-rotation
  install -m 0755 ${WORKDIR}/psplash-stop ${D}/opt/bin/psplash-stop
  install -d ${D}${bindir}
  install -m 0755 ${WORKDIR}/psplash-message ${D}${bindir}/psplash-message
}

do_install:append:rpi() {
  if [ "${@bb.utils.filter('DISTRO_FEATURES', 'systemd', d)}" ]; then
    install -Dm 0644 ${WORKDIR}/openvario-framebuf.conf ${D}${systemd_system_unitdir}/psplash-start.service.d/framebuf.conf
  fi
}

FILES:${PN} += "/opt"
