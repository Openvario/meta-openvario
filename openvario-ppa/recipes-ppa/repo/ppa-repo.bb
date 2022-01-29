SUMMARY = "Rebuilds the package repo"
LICENSE = "MIT"

DEPENDS = "\
    less \
    openvario-shell \
    openvario-shell-next \
    openvario-shell-autostart \
    openvario-compman \
    openvario-compman-next \
    ovmenu-compman \
    syncthing \
    python3-pip \
    xcsoar \
"

inherit nopackages

deltask do_fetch
deltask do_unpack
deltask do_patch
deltask do_configure
deltask do_compile
deltask do_populate_sysroot

DEPLOY_DIR_PPA = "${DEPLOY_DIR}/ppa"
PPA_UPLOAD_SCRIPT = "${DEPLOY_DIR}/ppa-upload.sh"
PPA_UPLOAD_DEST ?= "host:path"

do_populate_ppa[nostamp] = "1"
python do_populate_ppa() {
    from oe.rootfs import create_packages_dir

    create_packages_dir(d, d.getVar("DEPLOY_DIR_PPA"), d.getVar("DEPLOY_DIR_IPK"), "package_write_ipk", True)
}

do_index_ppa[nostamp] = "1"
do_index_ppa[depends] += "${PACKAGEINDEXDEPS}"
python do_index_ppa() {
    from oe.package_manager.ipk import OpkgIndexer

    indexer = OpkgIndexer(d, d.getVar("DEPLOY_DIR_PPA"))
    indexer.write_index()
}

do_build_ppa() {
    :
}

do_upload_ppa_script() {
    cat > ${PPA_UPLOAD_SCRIPT} << EOF
#!/bin/sh
rsync -v --progress  \
    --archive \
    --compress \
    --rsh=ssh \
    ${DEPLOY_DIR_PPA}/* \
    ${PPA_UPLOAD_DEST}
EOF
    chmod +x ${PPA_UPLOAD_SCRIPT}
    bbnote "Upload script is saved to ${PPA_UPLOAD_SCRIPT}"
}

addtask do_populate_ppa after do_build
addtask do_index_ppa after do_populate_ppa before do_build_ppa
addtask do_upload_ppa_script before do_build_ppa
addtask do_build_ppa after do_index_ppa

EXCLUDE_FROM_WORLD = "1"
