# inherit extrausers

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Scarthgap disables time64 for PulseAudio because its optional OSS wrapper
# overrides LFS64 functions.  Building PulseAudio with time32 while alsa-lib
# uses time64 corrupts snd_htimestamp_t on 32-bit ARM.  The OSS output/wrapper
# is unused here, so disable it and keep both components on the same ABI.
GLIBC_64BIT_TIME_FLAGS:pn-pulseaudio = " -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64"
EXTRA_OEMESON:append = " -Doss-output=disabled"

SRC_URI += "file://pulseaudio.service"

SYSTEMD_PACKAGES = "${PN}-server"
SYSTEMD_SERVICE:${PN}-server = "pulseaudio.service"
FILES:${PN}-server += " ${systemd_unitdir}/system/pulseaudio.service "

do_install:append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${B}/../pulseaudio.service ${D}${systemd_unitdir}/system
}
