# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r0"
RCONFLICTS:${PN}="xcsoar-testing"

SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=https;branch=v7.46.x "

# Commit version for 7.46.1:
SRCREV = "d1576b969331124eea52eb74370d6f364cc7a0a8"

BOOST_VERSION = "1.92.0"
BOOST_SHA256HASH = "5c1d40cb8e19adbf740a4ec2da35b3e58f3f5804b1dce44deb53df72193cbc6c"

require xcsoar.inc
