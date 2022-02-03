# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r0"
RCONFLICTS:${PN}="xcsoar-testing"

<<<<<<< HEAD
SRC_URI = "git://github.com/freevariode/XCSoar.git;protocol=git;tag=v${PV} \
           file://ov-xcsoar.conf"
=======
SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=git;tag=v${PV} \
"
>>>>>>> 8331c361ca536a822affd4e6970708f6c390ea02

require xcsoar.inc
