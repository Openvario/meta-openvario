SUMMARY = "Creates an 'openvario' account used for running XCSoar"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
PR = "r1"


SRC_URI = "file://.bash_profile \
"

inherit allarch useradd

do_configure() {
    :
}

do_compile() {
    :
}

do_install() {
	#install files in openvario home directory
	install -d ${D}/home/openvario
	install -m 0644 -o openvario -g openvario ${WORKDIR}/.bash_profile ${D}/home/openvario/

}


FILES_${PN} += " \
					/home/openvario/.bash_profile \
				"

USERADD_PACKAGES = "${PN}"
USERADD_PARAM_${PN} = "--create-home \
                       --groups video,tty,audio,input,shutdown,disk \
                       --user-group openvario"

