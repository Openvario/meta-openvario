# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "Foreign Function Interface for Python calling C code."
HOMEPAGE = "http://cffi.readthedocs.org"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   LICENSE
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5677e2fdbf7cdda61d6dd2b57df547bf"

SRC_URI[md5sum] = "74845f8d2b7b583dd9a3574f402edf39"
SRC_URI[sha256sum] = "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"

S = "${WORKDIR}/cffi-${PV}"

inherit pypi setuptools3

# WARNING: the following rdepends are from setuptools install_requires. These
# upstream names may not correspond exactly to bitbake package names.
RDEPENDS_${PN} += "python3-pycparser"

# WARNING: the following rdepends are determined through basic analysis of the
# python sources, and might not be 100% accurate.
RDEPENDS_${PN} += "python3-core python3-ctypes python3-distutils python3-io python3-math python3-shell python3-threading"

# WARNING: We were unable to map the following python package/module
# dependencies to the bitbake packages which include them:
#    _CFFI_test_import_from_lib.lib
#    _cffi_backend
#    _dummy_thread
#    _re_include_1
#    _test_import_from_lib.lib
#    imp
#    importlib.machinery
#    ply
#    py
#    pycparser.lextab
#    pycparser.yacctab
#    pytest
#    re_python_pysrc
#    setup
#    setuptools
#    setuptools.command.build_ext
#    setuptools.command.build_py
#    test_module_name_in_package.mymod
#    thread


