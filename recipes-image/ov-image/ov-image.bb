#Angstrom bootstrap image
#require console-base-image.bb
require ov-base-image.bb

#IMAGE_ROOTFS_SIZE = "3768320"

#IMAGE_FEATURES += "debug-tweaks"

IMAGE_INSTALL += "\
	variod \
	sensord \
	ovmenu-ng \
	"

#	    xcsoar xcsoar-profiles 
#       xcsoar-menu xcsoar-maps-default

export IMAGE_BASENAME = "ov-image"
