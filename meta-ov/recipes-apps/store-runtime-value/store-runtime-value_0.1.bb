# store-runtime-value.service
#
# This script installes a daemon that persistently stores runtime variables in config.uEnv 
# when the system is shut down, so that they can be read again after restart.
#
# Created by Blaubart         2023-03-30

SUMMARY = "Store runtime value"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"

PR = "r1"

inherit allarch systemd

RDEPENDS:${PN} = " \  
		bash \
"

SRC_URI = "              \
   file://store-runtime-value.service     \
   file://store-runtime-value.sh     \
   "
   
do_install() {
    install -d ${D}/${systemd_unitdir}/system
    install -d ${D}/opt/bin

    install -m 0644 ${WORKDIR}/store-runtime-value.service      ${D}/${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/store-runtime-value.sh           ${D}/opt/bin
}

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "store-runtime-value.service"

FILES:${PN} += " \
        ${systemd_unitdir}/system/store-runtime-value.service \
    	/opt/bin/store-runtime-value.sh \
"
