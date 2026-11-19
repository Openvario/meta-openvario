# IMAGE_VERSION_SUFFIX depends on the layer's Git working tree, which is not a
# normal BitBake metadata dependency.  Do not reuse parsed image metadata after
# HEAD or the dirty state changes.
BB_DONT_CACHE = "1"

python () {
    import subprocess

    try:
        # Get the path captured while meta-openvario's layer.conf was parsed.
        # Passing cwd=None would silently describe BitBake's working directory.
        layerdir = d.getVar('OPENVARIO_LAYERDIR')
        if not layerdir:
            raise RuntimeError("OPENVARIO_LAYERDIR is not set")
        
        # Tags are 5.<sequential>.<fix> and contain no dash: 5 is
        # Scarthgap, the second number the release, the third the
        # bugfix. A pre-release uses an underscore (5.0.9_PRE1).
        # git describe is copied into IMAGE_NAME, and fw-upgrade.sh
        # splits that name on "-CB2-".
        version = subprocess.check_output(
            ["git", "describe", "--tags", "--dirty", "--always"],
            cwd=layerdir,
            stderr=subprocess.DEVNULL
        ).strip().decode("utf-8")

        # Set the IMAGE_VERSION_SUFFIX variable to the Git revision
        d.setVar("IMAGE_VERSION_SUFFIX", version)
        
    except Exception as e:
        bb.warn("Could not get Git revision from meta-openvario: %s" % e)
}
