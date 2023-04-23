#
# install fix_cpu_freq service into systemd
# this this service runs /opt/bin/fix_cpu_freq.sh which fixes the CPU frequency at 720MHz
# this has proven to make OV very stable and reliable
# if you like to fix CPU speed at higher frequencies or want to allow frequency hopping for certain frequencies, change the settings in fix_cpu_freq.sh
#

SUMMARY = "Set CPU frequency to fixed value"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"

PR = "r1"

inherit allarch systemd

RDEPENDS:${PN} = " \
        bash \
"

SRC_URI = " \
        file://fix_cpu_freq.service \
	file://fix_cpu_freq.sh \
"

do_install() {
  install -d ${D}/${systemd_unitdir}/system
  install -d ${D}/opt/bin
  install -m 0644 ${WORKDIR}/fix_cpu_freq.service ${D}/${systemd_unitdir}/system
  install -m 0755 ${WORKDIR}/fix_cpu_freq.sh ${D}/opt/bin
}

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "fix_cpu_freq.service"

FILES:${PN} += " \
        ${systemd_unitdir}/system/fix_cpu_freq.service \
	/opt/bin/fix_cpu_freq.sh \
"
