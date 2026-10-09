# libXt 1.3.0 declares "static Boolean true = True;" in _XtShellAncestorSensitive
# and takes its address. That was valid C until C23 made true a keyword, and
# GCC 15, which Ubuntu 26.04 ships, defaults to C23 - so the native build of
# this recipe stops the whole image on a current host while the same source
# still compiles for the target with the cross compiler that scarthgap brings
# along. Pinning the dialect the code was written in is what oe-core itself
# does in comparable cases, and it costs nothing once the recipe moves to a
# version that upstream has corrected.
CFLAGS:append:class-native = " -std=gnu17"
