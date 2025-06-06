# eliminate the "python3" build-dependency
PACKAGES:remove = "${PN}-python"
do_install:append () {
	rm -f ${D}${bindir}/lsusb.py
}
