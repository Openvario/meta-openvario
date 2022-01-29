# Personal Package Archive for Openvario

A layer for OpenVario firmware build system that builds a personal package
archive (a.k.a. PPA), containing a set of extra applications, not shipped with
the official image. The layer is responsible for building `.ipk` packages and
`opkg` repository that can be uploaded to a public server.

## Packages included

* `openvario-shell` - [Alternative Openvario Menu](https://github.com/kedder/openvario-shell)
* `openvario-compman` - [Openvario Competition Manager](https://github.com/kedder/openvario-compman)
* `ovmenu-compman` - menu entry Competition Manager for Openvario menu system
* `syncthing` - [Syncthing](https://syncthing.net/), continuous file synchronization program

## Using the PPA

In order to use the PPA, you need to reference it in `opkg` configuration:

```
$ echo src kedder-ppa http://openvario.lebedev.lt/opkg/armv7vet2hf-neon >> /etc/opkg/customfeeds.conf
$ opkg update
```

Then packages can be installed using regular `opkg` commands, for example:

```
$ opkg install openvario-compman
```

## Building the PPA

In order to build the packages, this layer needs to be added to the working
openvario build. Check out [OpenVario build
instructions](https://github.com/Openvario/meta-openvario) for details on
setting up the build environment.

Edit `conf/bblayers.conf` and add a full path to directory with `openvario-ppa`
(this repository) sources.

Build can be configured using these variables in your `local.conf`:

* `PPA_UPLOAD_DEST` - destination for uploading the PPA repository. In
  `host:path` format

Building the ppa is done using this command:

```
$ bitbake ppa-repo -c build_ppa
```

The package archive will end up in `tmp/deploy/ppa` directory of the build
workspace directory. Build system also creates a shell script to upload
packages to the public server using rsync, which can be run from the shell:

```
$ tmp/deploy/ppa-upload.sh
```

## Adding new software to PPA

The list of packages included in the PPA is provided in `DEPENDS` variable of
`recipes-ppa/repo/ppa-repo.bb` recipe. New packages are added by creating build
recipes and referencing them in this variable.
