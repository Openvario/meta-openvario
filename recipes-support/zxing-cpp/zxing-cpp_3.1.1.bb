SUMMARY = "C++ barcode library with QR code reading and writing support"
HOMEPAGE = "https://github.com/zxing-cpp/zxing-cpp"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=fa818a259cbed7ce8bc2a22d35a464fc"

SRC_URI = "https://github.com/zxing-cpp/zxing-cpp/archive/v${PV}.tar.gz;downloadfilename=${BP}.tar.gz"
SRC_URI[sha256sum] = "7286b1e6ade66fe82b7c8208b4595deeb55d6486b410834fdc65702f46650542"

inherit cmake

EXTRA_OECMAKE = " \
    -DBUILD_SHARED_LIBS=ON \
    -DZXING_WRITERS=OLD \
    -DZXING_ENABLE_1D=OFF \
    -DZXING_ENABLE_AZTEC=OFF \
    -DZXING_ENABLE_DATAMATRIX=OFF \
    -DZXING_ENABLE_MAXICODE=OFF \
    -DZXING_ENABLE_PDF417=OFF \
    -DZXING_C_API=OFF \
    -DZXING_EXAMPLES=OFF \
    -DZXING_DEPENDENCIES=LOCAL \
    -DZXING_DISABLE_PCH=ON \
"
