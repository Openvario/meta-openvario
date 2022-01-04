
PACKAGES =+ "${PN}-rtl8192 "
LICENSE_${PN}-rtl8192 = "Firmware-rtlwifi_firmware"
FILES_${PN}-rtl8192 = " ${nonarch_base_libdir}/firmware/rtlwifi/rtl8192*.bin "
RDEPENDS_${PN}-rtl8192 += "${PN}-rtl-license"

PACKAGES =+ "${PN}-rtl8712 "
LICENSE_${PN}-rtl8712 = "Firmware-rtlwifi_firmware"
FILES_${PN}-rtl8712 = " ${nonarch_base_libdir}/firmware/rtlwifi/rtl8712*.bin "
RDEPENDS_${PN}-rtl8712 += "${PN}-rtl-license"

FILES_${PN}-rtl8192ce = " "
FILES_${PN}-rtl8192cu = " "
FILES_${PN}-rtl8192su = " "


