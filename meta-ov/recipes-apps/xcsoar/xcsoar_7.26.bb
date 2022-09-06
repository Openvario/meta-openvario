# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r0"
RCONFLICTS:${PN}="xcsoar-testing"

SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=https;branch=master \
"

SRCREV = "eb43747aff6f910e26114cbcbb90f91f2fe8058c"

# TODO remove this after 7.25 has been released with https://github.com/XCSoar/XCSoar/commit/7ce3070fee3a140b6a4d9437a2cfe9854f78abfe
EXTRA_CXXFLAGS = "-Wno-empty-body"
export EXTRA_CXXFLAGS

require xcsoar.inc
