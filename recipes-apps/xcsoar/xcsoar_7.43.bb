# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r1"
RCONFLICTS:${PN}="xcsoar-testing"

SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=https;branch=master "

# Commit version for 7.43:
SRCREV = "a7770b624ecdcddc37a7eb4bcda0ccb8394e9e58"

BOOST_VERSION = "1.85.0"
BOOST_SHA256HASH = "7009fe1faa1697476bdc7027703a2badb84e849b7b0baad5086b087b971f8617"

require xcsoar.inc
