# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r1"
RCONFLICTS:${PN}="xcsoar xcsoar-testing"

SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=https;branch=master "

# 7.43p2: Preview 2 for xcsoar 7.44
SRCREV = "9a036c372593dcb055871a495e892c8dc2ba2189"

BOOST_VERSION = "1.87.0"
BOOST_SHA256HASH = "af57be25cb4c4f4b413ed692fe378affb4352ea50fbe294a11ef548f4d527d89"

require xcsoar.inc
