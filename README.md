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

```
sudo docker run -it --rm -v $(pwd):/workdir linuxianer99/ovbuild --workdir=/workdir
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

Available machines are:
- openvario-7-PQ070
- openvario-7-CH070
- openvario-7-AM070
- openvario-57-lvds
- openvario-43-rgb

### Starting the build

```
bitbake openvario-image
```
or
```
bitbake openvario-image-testing
```
