DESCRIPTION = "Configuration files for online package repositories aka feeds"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

#PV = "${DISTRO_VERSION}"
PR = "r16"
PACKAGE_ARCH = "${MACHINE_ARCH}"

OPENVARIO_URI = "http://ftp.openvario.org/opkg"
USBSTICK_PATH = "file:///usb/usbstick/openvario/repo"

do_compile() {
	mkdir -p ${S}/${sysconfdir}/opkg
	
	# Create feeds for internet repos
	for feed in all armv7at2hf-vfp-neon openvario_7lvds openvario_43rgb; do
		  echo "src/gz ${feed} ${OPENVARIO_URI}/${feed}" > ${S}/${sysconfdir}/opkg/${feed}-feed.conf
	done

	# Create feeds for USB Stick
	for feed in all armv7at2hf-vfp-neon openvario_7lvds openvario_43rgb; do
                  echo "src/gz ${feed}-local ${USBSTICK_PATH}/${feed}" >> ${S}/${sysconfdir}/opkg/usb-local-feed.conf
        done

}

do_install () {
	install -d ${D}${sysconfdir}/opkg
	install -m 0644  ${S}/${sysconfdir}/opkg/* ${D}${sysconfdir}/opkg/
}

FILES_${PN} = "${sysconfdir}/opkg/*.conf \
					"

CONFFILES_${PN} += "${sysconfdir}/opkg/*.conf \
					"

# Get rid of opkg-collateral
RCONFLICTS_${PN} = "opkg-collateral"
RREPLACES_${PN} = "opkg-collateral"
RPROVIDES_${PN} = "opkg-collateral"

RRECOMMENDS_${PN} += "opkg"

