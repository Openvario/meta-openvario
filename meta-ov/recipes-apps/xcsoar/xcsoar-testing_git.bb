# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "r13"
RCONFLICTS:${PN}="xcsoar"

SRCREV:pn-xcsoar-testing = "${AUTOREV}" 

<<<<<<< HEAD
SRC_URI = "git://github.com/freevariode/XCSoar.git;protocol=git;branch=master \
           file://ov-xcsoar.conf"
=======
SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=git;branch=master \
"
>>>>>>> 8331c361ca536a822affd4e6970708f6c390ea02

require xcsoar.inc
