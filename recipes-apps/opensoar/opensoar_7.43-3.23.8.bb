# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "r0"
RCONFLICTS:${PN} = "opensoar-testing"

require openvario.inc

SRC_URI = "git://github.com/OpenSoaring/OpenSoar.git;protocol=https;branch=master "
# OpenSoar release tag: v7.43-3.23.8
# Pinned to upstream commit: 78fb41d82fae0f93fc90b61f9bd85a304c9d794c
SRCREV = "78fb41d82fae0f93fc90b61f9bd85a304c9d794c"

# Stable tag uses Boost 1.87.0
BOOST_VERSION = "1.87.0"
BOOST_SHA256HASH = "af57be25cb4c4f4b413ed692fe378affb4352ea50fbe294a11ef548f4d527d89"

require opensoar.inc
