SUMMARY = "NetCDF C++ library"
DESCRIPTION = "C++ interface to the NetCDF C data format library"
HOMEPAGE = "https://www.unidata.ucar.edu/software/netcdf/"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=7a265567ba44537b8d1ed8b406d4b25c"

DEPENDS = "libnetcdf"

SRC_URI = " \
    https://github.com/Unidata/netcdf-cxx4/archive/refs/tags/v${PV}.tar.gz \
    file://0002-fix-ncgroup-array-delete.patch \
"
SRC_URI[sha256sum] = "e3fe3d2ec06c1c2772555bf1208d220aab5fee186d04bd265219b0bc7a978edc"

S = "${WORKDIR}/netcdf-cxx4-${PV}"

# Autotools produces libnetcdf_c++4, matching OpenSoar's system-library path.
# It also avoids CMake's unconditional HDF5 lookup for our classic-only build.
inherit autotools pkgconfig

EXTRA_OECONF = " \
    --with-nc-config=no \
    --disable-filter-testing \
    --disable-static \
    --disable-doxygen \
"

# Keep build helpers and settings in the development package.
FILES:${PN}-dev += " \
    ${bindir}/ncxx4-config \
    ${libdir}/libnetcdf-cxx.settings \
"
