python () {
    import subprocess
    import os.path

    try:
        parentRepo = os.path.dirname(d.getVar("COREBASE", True))
        version = subprocess.check_output(["git", "describe", "--tags", "--dirty"], cwd = parentRepo, stderr = subprocess.DEVNULL).strip().decode('UTF-8')
        d.setVar("IMAGE_VERSION_SUFFIX", "-" + version)
    except:
        bb.warn("Could not get Git revision, image will have default version.")
}