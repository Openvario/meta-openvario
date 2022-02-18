# those ALSA definitions are useless for OpenVario, and omitting them
# saves 2 MB

RDEPENDS:alsa-lib:remove = "alsa-ucm-conf"
RDEPENDS:libatopology:remove = "alsa-topology-conf"

do_install:append () {
	rm -rf ${D}${datadir}/alsa/cards ${D}${datadir}/alsa/ctl ${D}${datadir}/alsa/pcm
}
