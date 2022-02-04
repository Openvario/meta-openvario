DESCRIPTION = "Syncthing - Open Source Continuous File Synchronization"
HOMEPAGE = "https://syncthing.net/"

LICENSE = "MPL-2.0"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=f75d2927d3c1ed2414ef72048f5ad640"
GO_IMPORT = "github.com/syncthing/syncthing"
SRC_URI = "git://${GO_IMPORT};protocol=git;branch=main;tag=v${PV} \
    file://0001-Remove-root-user-warning.patch;patchdir=src/${GO_IMPORT} \
    file://syncthing.service \
    "

inherit go systemd


FILES:${PN}-dev = ""

SYSTEMD_SERVICE:${PN} = "syncthing.service"

SYNCTHING_LDFLAGS = "-ldflags=' \
    -X github.com/syncthing/syncthing/lib/build.Version=v${PV} \
'"

# Go creates read-only files for downloaded modules. To be able to clean them,
# make them writable explicitly
python do_clean:prepend () {
    import subprocess

    wdir = d.expand("${WORKDIR}")
    subprocess.check_call(["chmod", "u+w", "-R", wdir])
}

do_compile() {
    cd src/${GO_IMPORT}
    GOARCH=${GOHOSTARCH} GOOS=${GOHOSTOS} GO111MODULE=on go generate ${GOBUILDFLAGS} ${GO_IMPORT}/lib/api/auto ${GO_IMPORT}/cmd/strelaypoolsrv/auto
    GO111MODULE=on ${GO} build ${GOBUILDFLAGS} ${SYNCTHING_LDFLAGS} ${GO_IMPORT}/cmd/syncthing
    chmod u+w -R ${WORKDIR}
}

do_install() {
        install -d ${D}${bindir}
        install -m 0755 ${B}/src/${GO_IMPORT}/syncthing ${D}${bindir}/
        install -d ${D}${systemd_unitdir}/system
        install -m 0755 ${B}/../syncthing.service ${D}${systemd_unitdir}/system
}

do_compile_ptest_base() {
    :
}
