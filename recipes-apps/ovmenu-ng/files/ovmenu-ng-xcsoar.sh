#!/bin/bash
# Sourced by ovmenu-ng.sh. Expects: do_shell(), start_app(), INPUT

# Config
TIMEOUT=3

# Seed XCSoar data directory from ~/.xcsoar/ (one-shot via mv).
# Packages install defaults to ~/.xcsoar/, but XCSoar runs with
# -datapath=data/XCSoarData on the data partition.
XCSOAR_DATADIR=$HOME/data/XCSoarData
if [ -d "$XCSOAR_DATADIR" ] && [ -d "$HOME/.xcsoar" ]; then
    for f in "$HOME/.xcsoar/"*; do
        echo "Seeding ${f##*/} -> XCSoarData/"
        mv "$f" "$XCSOAR_DATADIR/"
    done
    rmdir "$HOME/.xcsoar" 2>/dev/null
fi

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
	XCSoar) start_app; sync;;
	File) managed_in_xcsoar;;
	System) submenu_system;;
	Exit) yesno_exit;;
	Restart) yesno_restart;;
	Power_OFF) yesno_power_off;;
esac

done
}

function managed_in_xcsoar() {
	dialog --backtitle "OpenVario" \
		--title "[ X C S O A R ]" \
		--msgbox "This function is now managed in XCSoar." 8 50
}

function submenu_system() {
	### display system menu ###
	dialog --nocancel --backtitle "OpenVario" \
	--title "[ S Y S T E M ]" \
	--begin 3 4 \
	--menu "You can use the UP/DOWN arrow keys" 15 50 6 \
	Update_System "Update system software" \
	Calibrate_Sensors "Calibrate Sensors" \
	Calibrate_Touch "Calibrate Touch" \
	Settings "System Settings" \
	Information "System Info" \
	Back "Back to Main" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

	# make decision
	case $menuitem in
		Update_System)
			update_system
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
			managed_in_xcsoar
			;;
		LCD_Brightness)
			managed_in_xcsoar
			;;
		XCSoar_Language)
			managed_in_xcsoar
			;;
		SSH)
			submenu_ssh
			;;
		Back) ;;
	esac
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

	local restart_variod=false
	if systemctl --quiet is-active variod.service; then
		restart_variod=true
	fi

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
	if $restart_variod; then
		systemctl restart variod.service
	fi
}

function calibrate_touch() {
	echo "Calibrating Touch ..." >> /tmp/tail.$$
	/usr/bin/ov-calibrate-ts.sh >> /tmp/tail.$$
	dialog --msgbox "Calibration OK!" 10 50
}

function yesno_exit(){
	dialog --backtitle "Openvario" \
	--begin 3 4 \
	--defaultno \
	--title "Really exit ?" --yesno "Really want to go to console ??" 5 40

	response=$?
	case $response in
		0)
			select_app;;
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
	0) start_app; sync;;
	*) main_menu;;
esac
main_menu
