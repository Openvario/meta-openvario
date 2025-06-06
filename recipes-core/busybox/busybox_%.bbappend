FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://debloat.cfg \
	file://systemd.cfg \
	file://networking.cfg \
	file://no_swap.cfg \
	file://openssl.cfg \
"

DEPENDS:append = " openssl"

# This works around "do_package" failure "Didn't find service unit
# 'busybox-syslog.service', specified in
# SYSTEMD_SERVICE:busybox-syslog."
SYSTEMD_PACKAGES:remove = "${PN}-syslog"
