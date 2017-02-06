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
	XCSOAR_MAPS_FLARMNET=$(opkg list-installed xcsoar-maps-flarmnet | awk -F' ' '{print $3}')
	XCSOAR_MAPS_VERSION=$(opkg list-installed | grep "xcsoar-maps-" | awk -F' ' '{print $3}')
	IMAGE_VERSION=$(more /etc/version | awk -F' ' '{print $2}')
	SENSORD_VERSION=$(opkg list-installed sensord | awk -F' ' '{print $3}')
	VARIOD_VERSION=$(opkg list-installed variod | awk -F' ' '{print $3}')
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
	Flarmnet: $XCSOAR_MAPS_FLARMNET\n \
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
	XCSoar_Language 	"Set language used for XCSoar" \
	Back   "Back to Main" 2>"${INPUT}"
	
	menuitem=$(<"${INPUT}")

	# make decsion 
	case $menuitem in
		Display_Rotation)
			submenu_rotation
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
		--menu "Actual Setting is $XCSOAR_LANG \nSelect Language:" 15 50 4 \
		 system "Default system" \
		 de_DE.UTF-8 "German" \
		 2>"${INPUT}"
		 
		 menuitem=$(<"${INPUT}")

		# update config
		sed -i 's/^XCSOAR_LANG=.*/XCSOAR_LANG='$menuitem'/' /opt/conf/ov-xcsoar.conf
		dialog --msgbox "New Setting saved !!\n A Reboot is required !!!" 10 50	
	else
		dialog --backtitle "OpenVario" \
		--title "ERROR" \
		--msgbox "No Config found !!"
	fi
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
		# touch cal
		if [ -e $TOUCH_CAL ]; then
			cd /opt/bin
			./caltool -c $TOUCH_CAL -r $menuitem
			cp ./touchscreen.rules /etc/udev/rules.d/
			dialog --msgbox "New Setting saved !!\n A Reboot is required !!!" 10 50
		else
			dialog --msgbox "New Setting saved, but touch cal not valid !!\n A Reboot is required !!!" 10 50
		fi
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
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
	systemctl start sensord
}

function calibrate_touch() {
	echo "Calibrating Touch ..." >> /tmp/tail.$$
	# reset touch calibration
	# uboot rotation
	mount /dev/mmcblk0p1 /boot
	sed -i 's/^rotation=.*/rotation=0/' /boot/config.uEnv
	umount /dev/mmcblk0p1
	
	rm /opt/conf/touch.cal
	cp /opt/bin/touchscreen.rules.template /etc/udev/rules.d/touchscreen.rules
	udevadm control --reload-rules
	udevadm trigger
	sleep 2
	/opt/bin/caltool -c $TOUCH_CAL
	dialog --msgbox "Display rotation is RESET !!\nPlease set Display rotation again to apply calibration !!" 10 50
}

function update_maps() {
	echo "Updating Maps ..." > /tmp/tail.$$
	/usr/bin/update-maps.sh >> /tmp/tail.$$ 2>/dev/null &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function download_files() {
	echo "Downloading files ..." > /tmp/tail.$$
	/usr/bin/download-xcsoar.sh >> /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function download_igc_files() {
	echo "Downloading IGC files ..." > /tmp/tail.$$
	/usr/bin/download-igc.sh >> /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function upload_files(){
	echo "Uploading files ..." > /tmp/tail.$$
	/usr/bin/upload-xcsoar.sh >> /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function start_xcsoar() {
	/usr/bin/xcsoar_config.sh
	if [ -z $XCSOAR_LANG ]; then
		/opt/XCSoar/bin/xcsoar -fly -480x272
		openvt -f -c 1 /bin/echo; exit
	else
		LANG=$XCSOAR_LANG /opt/XCSoar/bin/xcsoar -fly -480x272
		openvt -f -c 1 /bin/echo; exit
	fi
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
