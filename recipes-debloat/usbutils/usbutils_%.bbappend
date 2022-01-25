# eliminate the "python3" build-dependency
PACKAGES:remove = "${PN}-python"
do_install_append () {
	rm -f ${D}${bindir}/lsusb.py
}
