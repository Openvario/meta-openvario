FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://systemd.cfg \
	file://networking.cfg \
	file://no_swap.cfg \
"

# This works around "do_package" failure "Didn't find service unit
# 'busybox-syslog.service', specified in
# SYSTEMD_SERVICE_busybox-syslog."
SYSTEMD_PACKAGES_remove = "${PN}-syslog"
