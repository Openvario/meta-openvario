#Angstrom bootstrap image
require console-base-image.bb

DEPENDS += "packagegroup-base-extended \
	   "

IMAGE_ROOTFS_SIZE = "3768320"

IMAGE_INSTALL += "packagegroup-base-extended \
		sunxi-mali \
		xcsoar \
		ttf-dejavu-common \
		ttf-dejavu-sans-condensed \
		ttf-dejavu-sans-mono \
		ttf-dejavu-sans \
		ttf-dejavu-serif-condensed \
		ttf-dejavu-serif \
		sensord \
		openvario-modules-conf \	
		openvario-modules-autoload \
		openvario-autologin \
		ovmenu-autostart \
		ovmenu \
		bash \
		vim \
		nano \
"

export IMAGE_BASENAME = "ov-image"
