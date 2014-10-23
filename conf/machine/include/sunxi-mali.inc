PREFERRED_PROVIDER_virtual/mesa ?= "mesa-gl"
PREFERRED_PROVIDER_virtual/libgl ?= "mesa-gl"
PREFERRED_PROVIDER_virtual/libgles1 ?= "sunxi-mali"
PREFERRED_PROVIDER_virtual/libgles2 ?= "sunxi-mali"
PREFERRED_PROVIDER_virtual/egl ?= "sunxi-mali"

XSERVER += "sunxi-mali \
            sunxi-mali-dev"

MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "\
 kernel-module-mali \
 kernel-module-mali-drm \
  "
