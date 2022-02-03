[![Automated Release Notes by gren](https://img.shields.io/badge/%F0%9F%A4%96-release%20notes-00B2EE.svg)](https://github-tools.github.io/github-release-notes/)

# meta-openvario // version for freevario device

This is a layer version for OpenEmbedded to support the Openvario hardware with freevario driver

## How to build an image

### Prerequisites

 - Linux installation 
 - Installed Docker (https://docs.docker.com/install/)
 
### Fetching sources

```
git clone https://github.com/freevariode/meta-openvario.git
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
