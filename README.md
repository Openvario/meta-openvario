[![Automated Release Notes by gren](https://img.shields.io/badge/%F0%9F%A4%96-release%20notes-00B2EE.svg)](https://github-tools.github.io/github-release-notes/)

# meta-openvario

This is a layer for OpenEmbedded to support the Openvario hardware

## How to build an image

### Prerequisites

 - Linux installation 
 - Installed Docker (https://docs.docker.com/install/)
 
### Fetching sources

```
git clone --recurse-submodules https://github.com/Openvario/meta-openvario.git
cd meta-openvario
```

This will fetch the sources including all submodules.

### Starting the containerd build environment
```
docker run -it --rm -v $(pwd):/workdir ghcr.io/openvario/ovbuild-container:main --workdir=/workdir
```

### Configuring the build (only necessary once after fetching the repos)

```
source openembedded-core/oe-init-build-env .
```

### Setting the machine

```
export MACHINE=ov-cb2-7-ch070
```

Available machines for the OpenVario with the original adapter board are:
- ov-cb2-43-rgb
- ov-cb2-57-lvds
- ov-cb2-7-ch070
- ov-cb2-7-pq070

Available machines for the OpenVario with the new adapter board DS2 are:
- ov-cb2-57-lvds-ds2
- ov-cb2-7-am070-ds2
- ov-cb2-7-ch070-ds2
- ov-cb2-7-pq070-ds2

Available machines for the OpenVario with RaspberryPi 4:
- ov-rpi4
- ov-rpi4-64


### Starting the build

```
bitbake openvario-image
```

### Write image to SD Card

for Raspberry PI
```
bmaptool copy --bmap <bmap-file.bmap> <wic-image.wic.*> /dev/sd[X]
```