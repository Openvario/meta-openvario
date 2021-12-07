[![Automated Release Notes by gren](https://img.shields.io/badge/%F0%9F%A4%96-release%20notes-00B2EE.svg)](https://github-tools.github.io/github-release-notes/)

# meta-openvario

This is a layer for OpenEmbedded to support the Openvario hardware

## How to build an image

### Prerequisites

 - Linux installation 
 - Installed Docker (https://docs.docker.com/install/)
 - Installed repo command (https://gerrit.googlesource.com/git-repo/+/refs/heads/master/README.md)
 
### Fetching sources

```
mkdir workdir
repo init -u git://github.com/Openvario/ovlinux-manifest.git -b warrior
repo sync
```

This will fetch the manifest file for the warrior branch.

### Starting the containerd build environment

The "old" Ubuntu 18.04 build container (for warrior branch):

```
sudo docker run -it --rm -v $(pwd):/workdir linuxianer99/ovbuild --workdir=/workdir
cd poky
```

The "new" Debian 11 build container (for hardknott branch):

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
bitbake openvario-image-testing
```
