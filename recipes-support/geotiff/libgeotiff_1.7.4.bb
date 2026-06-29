DESCRIPTION = "Library for reading and writing GeoTIFF files"
HOMEPAGE = "https://github.com/OSGeo/libgeotiff"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f80854a7049ee9433d1f93336fe22f10"

DEPENDS = "tiff zlib proj"

SRC_URI = "https://github.com/OSGeo/libgeotiff/releases/download/1.7.4/libgeotiff-1.7.4.tar.gz"
SRC_URI[sha256sum] = "c598d04fdf2ba25c4352844dafa81dde3f7fd968daa7ad131228cd91e9d3dc47"

inherit cmake

EXTRA_OECMAKE = "-DWITH_UTILITIES=OFF -DWITH_JPEG=OFF -DCMAKE_INSTALL_PREFIX=/usr"

do_install:append() {
    mkdir -p ${D}${libdir}/pkgconfig
    cat > ${D}${libdir}/pkgconfig/libgeotiff.pc << 'PCEOF'
prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: libgeotiff
Description: Library for reading and writing GeoTIFF files
Version: 1.7.4
Libs: -L${libdir} -lgeotiff
Cflags: -I${includedir}
Requires: proj
PCEOF
}

FILES:${PN} = "${libdir}/libgeotiff.so.* /usr/doc"
FILES:${PN}-dev = "${includedir} ${libdir}/libgeotiff.so ${libdir}/pkgconfig ${libdir}/cmake ${datadir}/cmake"
