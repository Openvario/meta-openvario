# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "Async http client/server framework (asyncio)"
HOMEPAGE = "https://github.com/aio-libs/aiohttp"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   LICENSE.txt
# NOTE: Original package / source metadata indicates license is: Apache
#
# NOTE: multiple licenses have been detected; they have been separated with &
# in the LICENSE value for now since it is a reasonable assumption that all
# of the licenses apply. If instead there is a choice between the multiple
# licenses then you should change the value to separate the licenses with |
# instead of &. If there is any doubt, check the accompanying documentation
# to determine which situation is applicable.
LICENSE = "Unknown & MIT & Apache"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=cf056e8e7a0a5477451af18b7b5aa98c \
                    file://vendor/http-parser/LICENSE-MIT;md5=9bfa835d048c194ab30487af8d7b3778"

SRC_URI[md5sum] = "ca40144c199a09fc1a141960cf6295f0"
SRC_URI[sha256sum] = "259ab809ff0727d0e834ac5e8a283dc5e3e0ecc30c4d80b3cd17a4139ce1f326"

S = "${WORKDIR}/aiohttp-${PV}"

inherit pypi setuptools3

# The following configs & dependencies are from setuptools extras_require.
# These dependencies are optional, hence can be controlled via PACKAGECONFIG.
# The upstream names may not correspond exactly to bitbake package names.
#
# Uncomment this line to enable all the optional features.
PACKAGECONFIG ?= "speedups"
PACKAGECONFIG[speedups] = "python3-aiodns python3-brotlipy python3-cchardet"

# WARNING: the following rdepends are from setuptools install_requires. These
# upstream names may not correspond exactly to bitbake package names.
RDEPENDS:${PN} += "python3-async-timeout python3-attrs python3-chardet python3-multidict python3-yarl"

# WARNING: the following rdepends are determined through basic analysis of the
# python sources, and might not be 100% accurate.
RDEPENDS:${PN} += "python3-core python3-crypt python3-datetime python3-email python3-io python3-json python3-logging python3-math python3-mime python3-misc python3-netclient python3-netserver python3-pickle"

# WARNING: We were unable to map the following python package/module
# dependencies to the bitbake packages which include them:
#    aiohttp._frozenlist
#    aiohttp._helpers
#    aiohttp._http_parser
#    aiohttp._http_writer
#    aiohttp._websocket
#    asyncio
#    asyncio.streams
#    attr
#    brotli
#    collections.abc
#    concurrent.futures
#    enum
#    gunicorn.config
#    gunicorn.workers
#    html
#    http.cookies
#    http.server
#    idna_ssl
#    pathlib
#    pytest
#    signal
#    tokio
#    typing
#    urllib.parse
#    urllib.request
#    uvloop


