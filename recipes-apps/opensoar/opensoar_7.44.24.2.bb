# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "r0"
RCONFLICTS:${PN} = "opensoar-testing"

require openvario.inc

SRC_URI = "git://github.com/OpenSoaring/OpenSoar.git;protocol=https;branch=master "
# Announced release 7.44.24.2 has no upstream tag; pin its release commit.
# Release announcement: OpenSoar-News.md at the revision below.
# https://github.com/OpenSoaring/OpenSoar/commit/e34b3dca3f63bf534c79657b22d181449350b9ca
SRCREV = "e34b3dca3f63bf534c79657b22d181449350b9ca"

# This release's bundled Boost version.
BOOST_VERSION = "1.90.0"
BOOST_SHA256HASH = "49551aff3b22cbc5c5a9ed3dbc92f0e23ea50a0f7325b0d198b705e8ee3fc305"

require opensoar.inc
