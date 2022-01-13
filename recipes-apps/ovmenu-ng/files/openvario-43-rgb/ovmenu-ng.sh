#!/bin/bash

#Config
TIMEOUT=3
INPUT=/tmp/menu.sh.$$

TOUCH_CAL=/opt/conf/touch.cal

#get config files
source /opt/conf/*.conf

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
	dialog --nocancel --backtitle "OpenVario" \
	--title "[ S Y S T E M ]" \
	--begin 3 4 \
	--menu "You can use the UP/DOWN arrow keys" 15 50 6 \
	Update_System   "Update system software" \
	Update_Maps   "Update Maps files" \
	Calibrate_Sensors   "Calibrate Sensors" \
	Calibrate_Touch   "Calibrate Touch" \
	Settings   "System Settings" \
	Information "System Info" \
	Back   "Back to Main" 2>"${INPUT}"
	
	menuitem=$(<"${INPUT}")
	
	# make decsion 
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
		Exit) ;;
	esac		
}

function show_info() {
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
		Back) ;;
	esac		
}

function submenu_xcsoar_lang() {
	if [ -n $XCSOAR_LANG ]; then
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
		sed -i 's/^XCSOAR_LANG=.*/XCSOAR_LANG='$menuitem'/' /opt/conf/ov-xcsoar.conf
		sync
		dialog --msgbox "New Setting saved !!\n A Reboot is required !!!" 10 50	
	else
		dialog --backtitle "OpenVario" \
		--title "ERROR" \
		--msgbox "No Config found !!"
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
	
	mount /dev/mmcblk0p1 /boot 
	TEMP=$(grep "rotation" /boot/config.uEnv)
	if [ -n $TEMP ]; then
		ROTATION=${TEMP: -1}
		dialog --nocancel --backtitle "OpenVario" \
		--title "[ S Y S T E M ]" \
		--begin 3 4 \
		--menu "Actual Setting is $ROTATION \nSelect Rotation:" 15 50 4 \
		 0 "Landscape 0 deg" \
		 1 "Portrait 90 deg" \
		 2 "Landscape 180 deg" \
		 3 "Portrait 270 deg" 2>"${INPUT}"
		 
		 menuitem=$(<"${INPUT}")

		# update config
		# uboot rotation
		sed -i 's/^rotation=.*/rotation='$menuitem'/' /boot/config.uEnv
		dialog --msgbox "New Setting saved !!\n Touch recalibration required !!\n A Reboot is required !!!" 10 50
	else
		dialog --backtitle "OpenVario" \
		--title "ERROR" \
		--msgbox "No Config found !!"
	fi
	
	umount /boot
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
	systemctl stop sensord
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
	systemctl start sensord
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
	/usr/bin/download-all.sh >> /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

# Copy /home/root/.xcsoar/logs to /usb/usbstick/openvario/igc
# Copy only *.igc files
function download_igc_files() {
	/usr/bin/download-igc.sh
}

# Copy /usb/usbstick/openvario/upload to /home/root/.xcsoar
function upload_files(){
	echo "Uploading files ..." > /tmp/tail.$$
	/usr/bin/upload-xcsoar.sh >> /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function start_xcsoar() {
	/usr/bin/xcsoar_config.sh
	if [ -z $XCSOAR_LANG ]; then
		/usr/bin/xcsoar -fly -480x272
	else
		LANG=$XCSOAR_LANG /usr/bin/xcsoar -fly -480x272
	fi
	sync
}

function yesno_exit(){
	dialog --backtitle "Openvario" \
	--begin 3 4 \
	--defaultno \
	--title "Really exit ?" --yesno "Really want to go to console ??" 5 40

	response=$?
	case $response in
		0) echo "Bye";exit 1;;
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

setfont cp866-8x14.psf.gz

DIALOG_CANCEL=1 dialog --nook --nocancel --pause "Starting XCSoar ... \\n Press [ESC] for menu" 10 30 $TIMEOUT 2>&1

case $? in
	0) start_xcsoar;;
	*) main_menu;;
esac
main_menu
