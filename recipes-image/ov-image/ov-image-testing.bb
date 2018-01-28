require ov-base-image.bb

#IMAGE_ROOTFS_SIZE = "3768320"

#IMAGE_FEATURES += "debug-tweaks"

IMAGE_INSTALL += "\
	xcsoar-testing \
	xcsoar-profiles \
	xcsoar-menu \
	xcsoar-maps-default \
	variod \
	sensord-testing \
	dhcp-client \
	ovmenu-ng \
	ovmenu-ng-autostart \
	"

export IMAGE_BASENAME = "ov-image-testing"
