# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r1"
RCONFLICTS:${PN}="xcsoar-testing"

SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=https;branch=master "

# Commit version for 7.44:
SRCREV = "a0dddd9088839c64bc1cdae9422044052b479b98"

BOOST_VERSION = "1.90.0"
BOOST_SHA256HASH = "49551aff3b22cbc5c5a9ed3dbc92f0e23ea50a0f7325b0d198b705e8ee3fc305"

require xcsoar.inc
