python () {
    import subprocess
    import os.path

    try:
        # Get the path to the meta-openvario layer
        layerdir = d.getVar('LAYERDIR_meta-openvario')
        
        # Get the Git revision from the meta-openvario layer
        version = subprocess.check_output(
            ["git", "describe", "--tags", "--dirty"],
            cwd=layerdir,
            stderr=subprocess.DEVNULL
        ).strip().decode("utf-8")

        # Set the IMAGE_VERSION_SUFFIX variable to the Git revision
        d.setVar("IMAGE_VERSION_SUFFIX", version)
        
    except Exception as e:
        bb.warn("Could not get Git revision from meta-openvario: %s" % e)
}