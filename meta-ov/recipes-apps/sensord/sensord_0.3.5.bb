# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "r1"

S = "${WORKDIR}/git"

inherit systemd

SRC_URI = "git://github.com/Openvario/sensord.git;protocol=https;tag=${PV} \
"

require sensord.inc
