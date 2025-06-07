# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r23.2"
# RCONFLICTS:${PN}="opensoar-dev"

require openvario.inc

## SRC_URI = "git://github.com/OpenSoaring/OpenSoar.git;protocol=https;branch=master " 
## # OpenSoar Tag: v7.42.22
## # SRCREV = "1ac45834b293d306164e2059657fc0c7d10633c2"
## # prev. (and old) Tag: 
## 
SRCREV = "804ac56de82b0b0554e91587037004a991f9eb78"

## OpenSoar: dev-branch
OPENSOAR = "${OpenSoar-Version}"
# PV="7.43.23.dev"
SRC_URI = "git:///mnt/d/Projects/OpenSoaring/OpenSoar/.git/;protocol=file;branch=dev-branch;tag=opensoar-7.43p2.23 "
SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/August2111/OpenSoar.git;protocol=https;branch=dev-branch "
# SRCREV = "${AUTOREV}"

# Revisoned 
SRCREV = "3d533839a880a38e7ff683e2e77fe328f21500a2"


# dev branch is: boost 1.87:
BOOST_VERSION = "1.87.0"
BOOST_SHA256HASH = "af57be25cb4c4f4b413ed692fe378affb4352ea50fbe294a11ef548f4d527d89"

require opensoar.inc

