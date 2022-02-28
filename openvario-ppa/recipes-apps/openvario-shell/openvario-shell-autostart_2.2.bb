SUMMARY = "Autostart openvario-shell"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=c79ff39f19dfec6d293b95dea7b07891"
PR = "r3"

inherit allarch systemd

SRC_URI = " \
    file://ovshell.service \
"

RCONFLICTS:${PN} = "ovmenu-ng"

SYSTEMD_SERVICE:${PN} = "ovshell.service"

# Override postinst to disable stopping the service on prerm because
# it would kill ovshell when it would try to upgrade itself (remove old
# version and install new one)
systemd_postinst() {
if systemctl >/dev/null 2>/dev/null; then
    OPTS=""

    if [ -n "$D" ]; then
        OPTS="--root=$D"
    fi

    if [ "${SYSTEMD_AUTO_ENABLE}" = "enable" ]; then
        for service in ${SYSTEMD_SERVICE_ESCAPED}; do
            systemctl ${OPTS} enable "$service"
        done
    fi

    if [ -z "$D" ]; then
        systemctl daemon-reload
        systemctl preset ${SYSTEMD_SERVICE_ESCAPED}
    fi
fi
}


do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/ovshell.service ${D}${systemd_unitdir}/system
}

RDEPENDS:${PN} = "bash ov-tools ovmenu-ng-skripts"
