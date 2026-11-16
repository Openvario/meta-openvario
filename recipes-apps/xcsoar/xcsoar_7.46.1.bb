# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r0"
RCONFLICTS:${PN}="xcsoar-testing"

SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=https;branch=v7.46.x "

# Commit version for 7.46.1:
SRCREV = "d1576b969331124eea52eb74370d6f364cc7a0a8"

require xcsoar.inc
