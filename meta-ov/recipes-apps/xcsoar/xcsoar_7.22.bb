# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r0"
RCONFLICTS:${PN}="xcsoar-testing"

SRC_URI = "git://github.com/freevariode/XCSoar.git;protocol=git;tag=v${PV} \
           file://ov-xcsoar.conf"

require xcsoar.inc
