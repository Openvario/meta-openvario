# eliminate the unnecessary "shared-mime-info" dependency
SHAREDMIMEDEP = ""

# eliminate the "python3" build-dependency
PACKAGES:remove = "${PN}-codegen"
do_install_append () {
	rm -rf ${D}${datadir}/glib-2.0/codegen
}
