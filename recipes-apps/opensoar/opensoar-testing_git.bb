# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "r0"
RCONFLICTS:${PN} = "opensoar"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/OpenSoaring/OpenSoar.git;protocol=https;branch=master "

# Current upstream master uses newer bundled 3rd-party versions than v7.43-3.23.8.
BOOST_VERSION = "1.90.0"
BOOST_SHA256HASH = "49551aff3b22cbc5c5a9ed3dbc92f0e23ea50a0f7325b0d198b705e8ee3fc305"
NETCDF_URL = "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.10.0.tar.gz"
NETCDF_HASH = "ce160f9c1483b32d1ba8b7633d7984510259e4e439c48a218b95a023dc02fd4c"
NETCDF_CXX_URL = "https://github.com/Unidata/netcdf-cxx4/archive/refs/tags/v4.3.1.tar.gz"
NETCDF_CXX_HASH = "e3fe3d2ec06c1c2772555bf1208d220aab5fee186d04bd265219b0bc7a978edc"

require opensoar.inc
