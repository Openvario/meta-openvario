FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# we have a different asound.state file for different machines
PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI += "file://run-lock.conf"

do_install:append() {
    install -d ${D}${exec_prefix}/lib/tmpfiles.d
    install -m 0644 ${WORKDIR}/run-lock.conf ${D}${exec_prefix}/lib/tmpfiles.d/
}

FILES:alsa-states:append = " ${exec_prefix}/lib/tmpfiles.d/run-lock.conf"
