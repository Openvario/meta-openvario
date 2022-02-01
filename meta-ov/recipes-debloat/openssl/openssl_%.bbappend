# eliminate the "perl" build-dependency
PACKAGES:remove = "${PN}-misc"
do_install:append () {
	rm -rf ${D}${libdir}/ssl-1.1/misc ${D}${bindir}/c_rehash
}
