setenv bootm_boot_mode sec
setenv bootargs console=${console} console=tty1 root=/dev/mmcblk0p2 rootwait panic=10
load mmc 0:1 0x43000000 script.bin
load mmc 0:1 0x42000000 uImage
bootm 0x42000000
