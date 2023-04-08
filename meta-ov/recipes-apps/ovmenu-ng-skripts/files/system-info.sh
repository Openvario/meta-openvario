### collect info of system
XCSOAR_VERSION=$(opkg list-installed xcsoar | awk -F' ' '{print $3}')
XCSOAR_MAPS_VERSION=$(opkg list-installed | grep "xcsoar-maps-" | awk -F' ' '{print $3}')
IMAGE_VERSION=$(cat /etc/os-release | grep VERSION_ID | awk -F'=' -F'"' '{print $2}')
SENSORD_VERSION=$(opkg list-installed sensord* | awk -F' ' '{print $3}')
VARIOD_VERSION=$(opkg list-installed variod* | awk -F' ' '{print $3}')
IP_ETH0=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
IP_WLAN=$(/sbin/ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

dialog --backtitle "OpenVario" \
--title "[ S Y S T E M I N F O ]" \
--begin 3 4 \
--msgbox " \
\n \
Image: $IMAGE_VERSION\n \
XCSoar: $XCSOAR_VERSION\n \
Maps: $XCSOAR_MAPS_VERSION\n \
sensord: $SENSORD_VERSION\n \
variod: $VARIOD_VERSION\n \
IP eth0: $IP_ETH0\n \
IP wlan0: $IP_WLAN\n \
" 15 50