# Include opkg feed file to usb stick
USB_FEED_URI = "file:///usb/usbstick/openvario/repo"

do_compile:append() {
    rm -f ${S}/${sysconfdir}/opkg/usb-feed.conf
    for feed in ${DISTRO_FEED_ARCHS}; do
        echo "src/gz usb-${feed} ${USB_FEED_URI}/${feed}" >> ${S}/${sysconfdir}/opkg/usb-feed.conf
    done
}
