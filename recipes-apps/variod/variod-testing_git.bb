require variod.inc
DESCRIPTION_append = " (Testing)"

PR = "r12"

SRCREV_pn-variod-testing = "${AUTOREV}" 

SRC_URI_append = " git://github.com/Openvario/variod.git;protocol=git;branch=master "

