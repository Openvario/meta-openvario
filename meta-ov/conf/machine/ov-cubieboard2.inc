# Common machine definitions for all Cubieboard2-based OpenVarios

# use the open source "Lima" Mali GPU driver
MACHINEOVERRIDES .= ":use-mailine-graphics"

# inherit the meta-sunxi "cubieboard2" machine
require conf/machine/cubieboard2.conf
MACHINEOVERRIDES =. "cubieboard2:"

MACHINE_FEATURES:remove = "apm"

IMAGE_CLASSES += "sdcard_image-openvario"
IMAGE_FSTYPES = "openvario-sdimg"
