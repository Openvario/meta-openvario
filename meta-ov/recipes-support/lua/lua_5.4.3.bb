DESCRIPTION = "Lua is a powerful light-weight programming language designed \
for extending applications."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://doc/readme.html;beginline=318;endline=352;md5=af9cf21da2719d2ffe92251babfa3b83"
HOMEPAGE = "http://www.lua.org/"

SRC_URI = "http://www.lua.org/ftp/lua-${PV}.tar.gz;name=tarballsrc \
           file://lua.pc.in \
           "
#           # file://0001-Allow-building-lua-without-readline-on-Linux.patch 
#           file://CVE-2020-15888.patch 
#           file://CVE-2020-15945.patch 
#           file://0001-Fixed-bug-barriers-cannot-be-active-during-sweep.patch 


# if no test suite matches PV release of Lua exactly, download the suite for the closest Lua release.
PV_testsuites = "5.3.4"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'ptest', \
           'http://www.lua.org/tests/lua-${PV_testsuites}-tests.tar.gz;name=tarballtest \
            file://run-ptest \
           ', '', d)}"
## Testsuite 5.4.3: lua-5.4.3-tests.tar.gz 	2021-03-15 size: 131911
## md5: 4afc92b7e45fc0687c686a470bc8072a
## sha1: 67b537204ee0311fcdd4f614b43d48fb146a7311

SRC_URI[tarballsrc.md5sum] = "ef63ed2ecfb713646a7fcc583cf5f352"
SRC_URI[tarballsrc.sh1sum] = "1dda2ef23a9828492b4595c0197766de6e784bc7"
# f8612276169e3bfcbcfb8f226195bfc6e466fe13042f1076cbde92b7ec96bbfb
# 5.3.6! SRC_URI[tarballsrc.md5sum] = "83f23dbd5230140a3770d5f54076948d"
# 5.3.6! SRC_URI[tarballsrc.sha256sum] = "fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60"
SRC_URI[tarballtest.md5sum] = "b14fe3748c1cb2d74e3acd1943629ba3"
SRC_URI[tarballtest.sha256sum] = "b80771238271c72565e5a1183292ef31bd7166414cd0d43a8eb79845fa7f599f"

inherit pkgconfig binconfig ptest

PACKAGECONFIG ??= "readline"
PACKAGECONFIG[readline] = ",,readline"

UCLIBC_PATCHES += "file://uclibc-pthread.patch"
SRC_URI:append:libc-uclibc = " ${UCLIBC_PATCHES}"

TARGET_CC_ARCH += " -fPIC ${LDFLAGS}"
EXTRA_OEMAKE = "'CC=${CC} -fPIC' 'MYCFLAGS=${CFLAGS} -fPIC' MYLDFLAGS='${LDFLAGS}'"

do_configure:prepend() {
    sed -i -e s:/usr/local:${prefix}:g src/luaconf.h
    sed -i -e s:lib/lua/:${baselib}/lua/:g src/luaconf.h
}

do_compile () {
    oe_runmake ${@bb.utils.contains('PACKAGECONFIG', 'readline', 'linux', 'linux-no-readline', d)}
}

do_install () {
    oe_runmake \
        'INSTALL_TOP=${D}${prefix}' \
        'INSTALL_BIN=${D}${bindir}' \
        'INSTALL_INC=${D}${includedir}/' \
        'INSTALL_MAN=${D}${mandir}/man1' \
        'INSTALL_SHARE=${D}${datadir}/lua' \
        'INSTALL_LIB=${D}${libdir}' \
        'INSTALL_CMOD=${D}${libdir}/lua/5.4' \
        install
    install -d ${D}${libdir}/pkgconfig

    sed -e s/@VERSION@/${PV}/ ${WORKDIR}/lua.pc.in > ${WORKDIR}/lua.pc
    sed -e s/@VERSION@/${PV}/ ${WORKDIR}/lua.pc.in > ${WORKDIR}/lua5.4.pc
    install -m 0644 ${WORKDIR}/lua.pc ${D}${libdir}/pkgconfig/
    install -m 0644 ${WORKDIR}/lua5.4.pc ${D}${libdir}/pkgconfig/
    rmdir ${D}${datadir}/lua/5.4
    rmdir ${D}${datadir}/lua
}

do_install_ptest () {
        cp -R --no-dereference --preserve=mode,links -v ${WORKDIR}/lua-${PV_testsuites}-tests ${D}${PTEST_PATH}/test
}

BBCLASSEXTEND = "native nativesdk"
