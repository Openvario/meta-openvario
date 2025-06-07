# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r7"
SRC_URI = "git://github.com/OpenSoaring/OpenSoar.git;protocol=https;branch=dev-branch"
### OpenSoar Tag: v7.41.21

###  SRCREV = ""
SRCREV = "${AUTOREV}"


BOOST_VERSION = "1.84.0"
BOOST_SHA256HASH = "cc4b893acf645c9d4b698e9a0f08ca8846aa5d6c68275c14c3e7949c24109454"

require opensoar.inc
