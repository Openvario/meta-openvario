setenv bootargs console=${console} console=tty1 root=/dev/mmcblk0p2 rootwait panic=10 ${extra}
load mmc 0:1 ${fdt_addr_r} ${fdtfile} || load mmc 0:1 ${fdt_addr_r} boot/${fdtfile}
load mmc 0:1 ${kernel_addr_r} zImage || load mmc 0:1 ${kernel_addr_r} boot/zImage || load mmc 0:1 ${kernel_addr_r} uImage || load mmc 0:1 ${kernel_addr_r} boot/uImage
bootz ${kernel_addr_r} - ${fdt_addr_r} || bootm ${kernel_addr_r} - ${fdt_addr_r}
