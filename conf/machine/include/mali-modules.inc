PREFERRED_PROVIDER_virtual/mesa ?= "mesa-gl"
PREFERRED_PROVIDER_virtual/libgl ?= "mesa-gl"
PREFERRED_PROVIDER_virtual/libgles1 ?= "mali-modules"
PREFERRED_PROVIDER_virtual/libgles2 ?= "mali-modules"
PREFERRED_PROVIDER_virtual/egl ?= "mali-modules"


MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "\
 kernel-module-mali \
 kernel-module-mali-drm \
  "
