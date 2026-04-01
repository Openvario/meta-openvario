#!/bin/bash

# Config
TIMEOUT=3
INPUT=/tmp/menu.sh.$$

# trap and delete temp files
trap "rm $INPUT;rm /tmp/tail.$$; exit" SIGHUP SIGINT SIGTERM

main_menu () {
while true
do
	### display main menu ###
	dialog --clear --nocancel --backtitle "OpenVario" \
	--title "[ M A I N - M E N U ]" \
	--begin 3 4 \
	--menu "You can use the UP/DOWN arrow keys" 15 50 6 \
	XCSoar   "Start XCSoar" \
	File   "Copys file to and from OpenVario" \
	System   "Update, Settings, ..." \
	Exit   "Exit to the shell" \
	Restart "Restart" \
	Power_OFF "Power OFF" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

	# make decsion
case $menuitem in
	XCSoar) start_xcsoar;;
	File) submenu_file;;
	System) submenu_system;;
	Exit) yesno_exit;;
	Restart) yesno_restart;;
	Power_OFF) yesno_power_off;;
esac

done
}

function submenu_file() {

	### display file menu ###
	dialog --nocancel --backtitle "OpenVario" \
	--title "[ F I L E ]" \
	--begin 3 4 \
	--menu "You can use the UP/DOWN arrow keys" 15 50 4 \
	Download_IGC   "Download XCSoar IGC files to USB" \
	Download   "Download XCSoar to USB" \
	Upload   "Upload files from USB to XCSoar" \
	Back   "Back to Main" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

	# make decsion
	case $menuitem in
		Download_IGC) download_igc_files;;
		Download) download_files;;
		Upload) upload_files;;
		Exit) ;;
esac
}

function submenu_system() {
	### display system menu ###
	# Build system menu items. Include Network only if nmcli exists.
	SYSTEM_MENU_ITEMS=(
		Update_System "Update system software"
		Update_Maps "Update Maps files"
		Calibrate_Sensors "Calibrate Sensors"
		Calibrate_Touch "Calibrate Touch"
		Settings "System Settings"
		Information "System Info"
	)

	if command -v nmcli >/dev/null 2>&1; then
		SYSTEM_MENU_ITEMS+=(Network "Network Options")
	fi

	SYSTEM_MENU_ITEMS+=(Back "Back to Main")

	MENU_COUNT=${#SYSTEM_MENU_ITEMS[@]}
	MENU_LINES=$(( MENU_COUNT / 2 ))

	dialog --nocancel --backtitle "OpenVario" \
	--title "[ S Y S T E M ]" \
	--begin 3 4 \
	--menu "You can use the UP/DOWN arrow keys" 15 50 $MENU_LINES \
	"${SYSTEM_MENU_ITEMS[@]}" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

	# make decision
	case $menuitem in
		Update_System)
			update_system
			;;
		Update_Maps)
			update_maps
			;;
		Calibrate_Sensors)
			calibrate_sensors
			;;
		Calibrate_Touch)
			calibrate_touch
			;;
		Settings)
			submenu_settings
			;;
		Information)
			show_info
			;;
		Network)
			submenu_network
			;;
		Back) ;;
	esac
}

function submenu_settings() {
	### display settings menu ###
	dialog --nocancel --backtitle "OpenVario" \
	--title "[ S Y S T E M ]" \
	--begin 3 4 \
	--menu "You can use the UP/DOWN arrow keys" 15 50 5 \
	Display_Rotation 	"Set rotation of the display" \
	LCD_Brightness		"Set display brightness" \
	XCSoar_Language 	"Set language used for XCSoar" \
	SSH			"Enable or disable SSH" \
	Back   "Back to Main" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

	# make decsion
	case $menuitem in
		Display_Rotation)
			submenu_rotation
			;;
		LCD_Brightness)
			submenu_lcd_brightness
			;;
		XCSoar_Language)
			submenu_xcsoar_lang
			;;
		SSH)
			submenu_ssh
			;;
		Back) ;;
	esac
}

function submenu_network() {
	dialog --nocancel --backtitle "OpenVario" \
	--title "[ N E T W O R K ]" \
	--begin 3 4 \
	--menu "You can use the UP/DOWN arrow keys" 15 50 4 \
	Scan_WiFi     "Scan for available WiFi networks" \
	Set_Country   "Set WiFi country code" \
	Back          "Back to System Menu" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

	case $menuitem in
		Scan_WiFi) scan_wifi_networks;;
		Set_Country) do_wifi_country;;
		Back) ;;
	esac
}


function scan_wifi_networks() {
	nmcli radio wifi on >/dev/null 2>&1

	declare -A SSID_MAP
	SCAN_LIST=()
	current_ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')

	# parse nmcli output: SSID:SIGNAL:... (ignore empty SSIDs)
	while IFS=":" read -r ssid signal rest; do
		[ -z "$ssid" ] && continue
		if [[ -z "${SSID_MAP[$ssid]}" ]]; then
			SSID_MAP["$ssid"]=1
			display_name="(Signal: $signal)"
			if [[ "$ssid" == "$current_ssid" ]]; then
				display_name="$display_name [Connected]"
			fi
			SCAN_LIST+=("$ssid" "$display_name")
		fi
	done < <(nmcli -t -f SSID,SIGNAL dev wifi list)

	if [ ${#SCAN_LIST[@]} -eq 0 ]; then
		dialog --backtitle "OpenVario" --msgbox "No WiFi networks found." 10 40
	else
		dialog --backtitle "OpenVario" \
		--title "[ WiFi Networks ]" \
		--menu "Detected WiFi networks" 20 60 $(( ${#SCAN_LIST[@]} / 2 )) \
		"${SCAN_LIST[@]}" 2>"${INPUT}"

		chosen_ssid=$(<"${INPUT}")
		if [ -n "$chosen_ssid" ]; then
			dialog --backtitle "OpenVario" \
			--title "[ WiFi Password ]" \
			--insecure --passwordbox "Enter password for '$chosen_ssid':" 10 50 2>"${INPUT}"
			wifi_pass=$(<"${INPUT}")

			if [ -z "$wifi_pass" ]; then
				nmcli dev wifi connect "$chosen_ssid" && \
				dialog --backtitle "OpenVario" --msgbox "Successfully connected to '$chosen_ssid'." 10 40 || \
				dialog --backtitle "OpenVario" --msgbox "Failed to connect to '$chosen_ssid'." 10 40
			else
				nmcli dev wifi connect "$chosen_ssid" password "$wifi_pass" && \
				dialog --backtitle "OpenVario" --msgbox "Successfully connected to '$chosen_ssid'." 10 40 || \
				dialog --backtitle "OpenVario" --msgbox "Failed to connect to '$chosen_ssid'." 10 40
			fi
		fi
	fi
}

function do_wifi_country() {
	value=$(sed '/^#/d' /usr/share/zoneinfo/iso3166.tab | tr '\t' ' ')

	# Liste der Länder in ein Array umwandeln
	COUNTRY_LIST=()
	while read -r code name; do
		COUNTRY_LIST+=("$code" "$name")
	done <<< "$value"

	# Auswahlmenü anzeigen
	dialog --backtitle "OpenVario" \
	--title "[ WiFi Country Selection ]" \
	--begin 3 4 \
	--menu "Select the country in which the device is used" 20 60 15 \
	"${COUNTRY_LIST[@]}" 2>"${INPUT}"

	REGDOMAIN=$(<"${INPUT}")

	# Wenn kein Land ausgewählt wurde
	if [ -z "$REGDOMAIN" ]; then
		return 1
	fi

	# Validierung
	if ! grep -q "^${REGDOMAIN}[[:space:]]" /usr/share/zoneinfo/iso3166.tab; then
		dialog --backtitle "OpenVario" \
		--title "[ Error ]" \
		--msgbox "$REGDOMAIN is not a valid ISO/IEC 3166-1 alpha2 code" 10 50
		return 1
	fi

	# Systemkonfiguration aktualisieren
	sed -i \
		-e "s/\s*cfg80211.ieee80211_regdom=\S*//" \
		-e "s/\(.*\)/\1 cfg80211.ieee80211_regdom=$REGDOMAIN/" \
		"$CMDLINE"

	if is_installed crda && [ -e /etc/default/crda ]; then
		rm -f /etc/default/crda
	fi

	if ! ischroot; then
		iw reg set "$REGDOMAIN"
	fi

	IFACE="$(list_wlan_interfaces | head -n 1)"
	if [ "$INIT" = "systemd" ] && [ -n "$IFACE" ] && systemctl -q is-active dhcpcd; then
		wpa_cli -i "$IFACE" set country "$REGDOMAIN" > /dev/null 2>&1
		wpa_cli -i "$IFACE" save_config > /dev/null 2>&1
	fi

	if [ "$INIT" = "systemd" ] && ! ischroot && systemctl -q is-active NetworkManager; then
		nmcli radio wifi on
	elif hash rfkill 2> /dev/null; then
		rfkill unblock wifi
		if [ -f /var/lib/NetworkManager/NetworkManager.state ]; then
			sed -i 's/^WirelessEnabled=.*/WirelessEnabled=true/' /var/lib/NetworkManager/NetworkManager.state
		fi
	fi

	if is_pi; then
		for filename in /var/lib/systemd/rfkill/*:wlan ; do
			[ -e "$filename" ] && echo 0 > "$filename"
		done
	fi

	dialog --backtitle "OpenVario" \
	--title "[ Country Set ]" \
	--msgbox "Wireless LAN country set to $REGDOMAIN" 8 50
}

function show_info() {
	### collect info of system
	XCSOAR_VERSION=$(opkg list-installed xcsoar | awk -F' ' '{print $3}')
	XCSOAR_MAPS_VERSION=$(opkg list-installed | grep "xcsoar-maps-" | awk -F' ' '{print $3}')
	IMAGE_VERSION=$(cat /etc/os-release | grep VERSION_ID | awk -F'=' -F'"' '{print $2}')
	SENSORD_VERSION=$(opkg list-installed sensord* | awk -F' ' '{print $3}')
	
	VARIOD_VERSION=$(opkg list-installed variod* | awk -F' ' '{print $3}')
	IP_ETH0=$(ip -4 addr show eth0 | grep -w inet | head -n1 | awk '{print $2}' | cut -d/ -f1)
	IP_WLAN=$(ip -4 addr show wlan0 | grep -w inet | head -n1 | awk '{print $2}' | cut -d/ -f1)

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
}

function submenu_xcsoar_lang() {
	if test -n "$LANG"; then
		XCSOAR_LANG="$LANG"
	else
		XCSOAR_LANG="system"
	fi

	dialog --nocancel --backtitle "OpenVario" \
		--title "[ S Y S T E M ]" \
		--begin 3 4 \
		--menu "Actual Setting is $XCSOAR_LANG \nSelect Language:" 15 50 12 \
		 system "Default system" \
		 de_DE.UTF-8 "German" \
		 fr_FR.UTF-8 "France" \
		 it_IT.UTF-8 "Italian" \
		 hu_HU.UTF-8 "Hungary" \
		 pl_PL.UTF-8 "Poland" \
		 cs_CZ.UTF-8 "Czech" \
		 sk_SK.UTF-8 "Slowak" \
		 lt_LT.UTF-8 "Lithuanian" \
		 ru_RU.UTF-8 "Russian" \
		 es_ES.UTF-8 "Espanol" \
		 nl_NL.UTF-8 "Dutch" \
		 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

	# update config
	localectl set-locale "$menuitem"
	sync

	export LANG="$menuitem"
}

function submenu_ssh() {
	if /bin/systemctl --quiet is-enabled dropbear.socket; then
		local state=enabled
	elif /bin/systemctl --quiet is-active dropbear.socket; then
		local state=temporary
	else
		local state=disabled
	fi

	dialog --nocancel --backtitle "OpenVario" \
		--title "[ S S H ]" \
		--begin 3 4 \
		--default-item "${state}" \
		--menu "SSH access is currently ${state}." 15 50 4 \
		enabled "Enable SSH permanently" \
		temporary "Enable SSH temporarily (until reboot)" \
		disabled "Disable SSH" \
		2>"${INPUT}"
	menuitem=$(<"${INPUT}")

	if test "${state}" != "$menuitem"; then
		if test "$menuitem" = "enabled"; then
			/bin/systemctl enable --now dropbear.socket
		elif test "$menuitem" = "temporary"; then
			/bin/systemctl disable dropbear.socket
			/bin/systemctl start dropbear.socket
		else
			/bin/systemctl disable --now dropbear.socket
		fi
	fi
}

function submenu_lcd_brightness() {
while [ $? -eq 0 ]
do
	menuitem=$(</sys/class/backlight/lcd/brightness)
	dialog --backtitle "OpenVario" \
	--title "LCD brightness" \
	--cancel-label Back \
	--ok-label Set \
	--default-item "${menuitem}" \
	--menu "Brightness value" \
	17 50 10 \
	1 "Dark" \
	2 "" \
	3 "" \
	4 "" \
	5 "Medium" \
	6 "" \
	7 "" \
	8 "" \
	9 "" \
	10 "Bright" \
	2>/sys/class/backlight/lcd/brightness
done
	submenu_settings
}

function submenu_rotation() {
	TEMP=$(grep "rotation" /boot/config.uEnv)
	if [ -n $TEMP ]; then
		ROTATION=${TEMP: -1}
		dialog --nocancel --backtitle "OpenVario" \
		--title "[ S Y S T E M ]" \
		--begin 3 4 \
		--default-item "${ROTATION}" \
		--menu "Select Rotation:" 15 50 4 \
		 0 "Landscape 0 deg" \
		 1 "Portrait 90 deg" \
		 2 "Landscape 180 deg" \
		 3 "Portrait 270 deg" 2>"${INPUT}"

		 menuitem=$(<"${INPUT}")

		# update config
		# uboot rotation
		sed -i 's/fbcon=rotate:.*/fbcon=rotate:'${menuitem}'/' /boot/cmdline.txt
		echo "$menuitem" >/sys/class/graphics/fbcon/rotate_all
		dialog --msgbox "New Setting saved !!\n Touch recalibration required !!" 10 50
	else
		dialog --backtitle "OpenVario" \
		--title "ERROR" \
		--msgbox "No Config found !!"
	fi
}

function update_system() {

	echo "Updating System ..." > /tmp/tail.$$
	opkg update &>/dev/null
	OPKG_UPDATE=$(opkg list-upgradable)

	dialog --backtitle "Openvario" \
	--begin 3 4 \
	--defaultno \
	--title "Update" --yesno "$OPKG_UPDATE" 15 40

	response=$?
	case $response in
		0) opkg upgrade &>/tmp/tail.$$
		sync
		dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
		;;
	esac
}

function calibrate_sensors() {

	dialog --backtitle "Openvario" \
	--begin 3 4 \
	--defaultno \
	--title "Sensor Calibration" --yesno "Really want to calibrate sensors ?? \n This takes a few moments ...." 10 40

	response=$?
	case $response in
		0) ;;
		*) return 0
	esac

	echo "Calibrating Sensors ..." >> /tmp/tail.$$
	systemctl stop variod.service sensord.socket 'sensord@*.service'
	/opt/bin/sensorcal -c > /tmp/tail.$$

	if [ $? -eq 2 ]
	then
		# board not initialised
		dialog --backtitle "Openvario" \
		--begin 3 4 \
		--defaultno \
		--title "Init Sensorboard" --yesno "Sensorboard is virgin ! \n Do you want to initialize ??" 10 40

		response=$?
		case $response in
			0) /opt/bin/sensorcal -i > /tmp/tail.$$
			;;
		esac
		echo "Please run sensorcal again !!!" > /tmp/tail.$$
	fi
	sync
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
	systemctl restart variod.service
}

function calibrate_touch() {
	echo "Calibrating Touch ..." >> /tmp/tail.$$
	/usr/bin/ov-calibrate-ts.sh >> /tmp/tail.$$
	dialog --msgbox "Calibration OK!" 10 50
}

# Copy /usb/usbstick/openvario/maps to /home/root/.xcsoar
# Copy only xcsoar-maps*.ipk and *.xcm files
function update_maps() {
	echo "Updating Maps ..." > /tmp/tail.$$
	/usr/bin/update-maps.sh >> /tmp/tail.$$ 2>/dev/null &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

# Copy /home/root/.xcsoar to /usb/usbstick/openvario/download/xcsoar
function download_files() {
	echo "Downloading files ..." > /tmp/tail.$$
	/usr/bin/download-all.sh >> /tmp/tail.$$ 2>&1 &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

# Copy /home/root/.xcsoar/logs to /usb/usbstick/openvario/igc
# Copy only *.igc files
function download_igc_files() {
	echo "Downloading IGC files ..." > /tmp/tail.$$
	/usr/bin/download-igc.sh download-igc xcsoar >> /tmp/tail.$$ 2>&1 &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

# Copy /usb/usbstick/openvario/upload to /home/root/.xcsoar
function upload_files(){
	echo "Uploading files ..." > /tmp/tail.$$
	/usr/bin/upload-xcsoar.sh >> /tmp/tail.$$ 2>&1 &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function start_xcsoar() {
	/usr/bin/xcsoar -fly
	sync
}

function yesno_exit(){
	dialog --backtitle "Openvario" \
	--begin 3 4 \
	--defaultno \
	--title "Really exit ?" --yesno "Really want to go to console ??" 5 40

	response=$?
	case $response in
		0)
			clear
			cd

			# Redirecting stderr to stdout (= the console)
			# because stderr is currently connected to
			# systemd-journald, which breaks interactive
			# shells.
			if test -x /bin/bash; then
				/bin/bash --login 2>&1
			elif test -x /bin/ash; then
				/bin/ash -i 2>&1
			else
				/bin/sh 2>&1
			fi
			;;
	esac
}

function yesno_restart(){
	dialog --backtitle "Openvario" \
	--begin 3 4 \
	--defaultno \
	--title "Really restart ?" --yesno "Really want to restart ??" 5 40

	response=$?
	case $response in
		0) reboot;;
	esac
}

function yesno_power_off(){
	dialog --backtitle "Openvario" \
	--begin 3 4 \
	--defaultno \
	--title "Really Power-OFF ?" --yesno "Really want to Power-OFF" 5 40

	response=$?
	case $response in
		0) shutdown -h now;;
	esac
}

DIALOG_CANCEL=1 dialog --nook --nocancel --pause "Starting XCSoar ... \\n Press [ESC] for menu" 10 30 $TIMEOUT 2>&1

case $? in
	0) start_xcsoar;;
	*) main_menu;;
esac
main_menu
