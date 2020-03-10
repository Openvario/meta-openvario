FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# do-not-wait-for-online.patch - by default, autofs systemd service will wait
# until system goes online. Since Openvario will not typically be online,
# autofs will not load until do-not-wait-for-online.patch fails after time-out.
# This happens approx 2 minutes after startup. The patch removes dependency on
# networking services to boot autofs up faster.

# no-sample-mounts.patch - remove sample mount points from autofs. We only care
# about /usb mount point, that comes with autofs-config package.

SRC_URI += "file://do-not-wait-for-online.patch \
           file://no-sample-mounts.patch \
           "

# Do not run update-rc.d during the build. The command fails and generrates
# build error. We use systemd instead of rc.d style init, so we don't care.
updatercd_postinst() {
    :
}