# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "r1"

S = "${WORKDIR}/git"

inherit systemd

SRC_URI = "git://github.com/Openvario/sensord.git;protocol=https;branch=master"

SRCREV = "465e3560583266aa9e1f161c7a3d43207f2b9e08"

require sensord.inc
