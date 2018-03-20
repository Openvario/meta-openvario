FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://openvario_defconfig \
	file://boot.cmd \
	file://config.uEnv \
	file://0001-Environment-Openvario.patch \
	file://ov_recover_0.bmp \
	file://ov_recover_1.bmp \
	file://ov_recover_2.bmp \
	file://ov_recover_3.bmp \
	file://ov_booting_0.bmp \
	file://ov_booting_1.bmp \
	file://ov_booting_2.bmp \
	file://ov_booting_3.bmp \
	"
	
do_configure_prepend() {
    cp ${WORKDIR}/openvario_defconfig ${S}/configs/openvario_defconfig
}

do_install_append() {
    if [ -e ${WORKDIR}/ov_recover_0.bmp ] ; then
	install -m 644 -D ${WORKDIR}/ov_*.bmp ${D}/boot
    fi
	
	if [ -e ${WORKDIR}/config.uEnv ] ; then
	install -m 644 -D ${WORKDIR}/config.uEnv ${D}/boot
    fi
}

do_deploy_append() {
    if [ -e ${WORKDIR}/ov_recover_0.bmp ] ; then
	install -d ${DEPLOYDIR}/pics
        install -m 644 -D ${WORKDIR}/ov_*.bmp ${DEPLOYDIR}/pics
    fi
	
	if [ -e ${WORKDIR}/config.uEnv ] ; then
	install -m 644 -D ${WORKDIR}/config.uEnv ${DEPLOYDIR} 
    fi
}
