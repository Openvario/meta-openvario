[![Automated Release Notes by gren](https://img.shields.io/badge/%F0%9F%A4%96-release%20notes-00B2EE.svg)](https://github-tools.github.io/github-release-notes/)

# !!! SWITCH TO MASTER BRANCH !!!
# !!! Please use do not use these branch any longer !!!


# meta-openvario

This is a layer for OpenEmbedded to support the Openvario hardware

## How to build an image

### Prerequisites

 - Linux installation 
 - Installed Docker (https://docs.docker.com/install/)
 - Installed repo command (https://gerrit.googlesource.com/git-repo/+/refs/heads/master/README.md)
 
### Fetching sources

```
repo init -u git://github.com/Openvario/ovlinux-manifest.git -b hardknott
repo sync
```

This will fetch the manifest file for the Hardknott branch.

### Starting the containerd build environment
```
sudo docker run -it --rm -v $(pwd):/workdir ghcr.io/openvario/ovbuild-container:main --workdir=/workdir
cd poky
```

### Configuring the build (only necessary once after fetching the repos)

```
TEMPLATECONF=meta-openvario/conf source oe-init-build-env
```

### Setting the machine

```
export MACHINE=openvario-7-CH070
```

Available machines for the OpenVario with the original adapter board are:
- openvario-7-PQ070
- openvario-7-CH070
- openvario-57-lvds
- openvario-43-rgb

Available machines for the OpenVario with the new adapter board DS2 are:
- openvario-7-CH070-DS2
- openvario-7-AM070-DS2
- openvario-57-lvds-DS2

### Starting the build

```
bitbake openvario-image
```
