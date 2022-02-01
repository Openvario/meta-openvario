# eliminate the "python3-dbus" build-dependency
PACKAGES:remove = "${PN}-testtools"
do_install:append () {
	rm -rf ${D}${libdir}/bluez
}
