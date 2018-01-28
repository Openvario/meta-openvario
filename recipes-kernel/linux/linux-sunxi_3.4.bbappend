FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
		file://defconfig \
		file://0001-Bugfix-sun4i-ts-exchange-x_y-flag.patch \
		file://0001-Added-lcd_swap-parameter-to-display-driver.patch \
		"
