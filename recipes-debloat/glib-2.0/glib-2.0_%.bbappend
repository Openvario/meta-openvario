# eliminate the unnecessary "shared-mime-info" dependency
SHAREDMIMEDEP = ""

# eliminate the "python3" build-dependency
PACKAGES:remove:cubieboard2 = "${PN}-codegen"
do_install:append:cubieboard2 () {
	rm -rf ${D}${datadir}/glib-2.0/codegen
}
