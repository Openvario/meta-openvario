# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION:append = " (Testing)"

PR = "r11"

S = "${WORKDIR}/git"

inherit systemd

SRC_URI = "git://github.com/Openvario/sensord.git;protocol=https;branch=master"

SRCREV:pn-sensord-testing = "${AUTOREV}" 

require sensord.inc