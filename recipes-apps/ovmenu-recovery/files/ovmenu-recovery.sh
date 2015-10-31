#!/bin/bash

DIALOGRC=/opt/bin/openvario.rc

#Config
TIMEOUT=3
INPUT=/tmp/menu.sh.$$
DIRNAME=/mnt/openvario

#Target device (typically /dev/mmcblk0)
TARGET=/dev/mmcblk0

# trap and delete temp files
trap "rm $INPUT;rm /tmp/tail.$$; exit" SIGHUP SIGINT SIGTERM

main_menu () {
while true
do
	### display main menu ###
	dialog --clear --nocancel --backtitle "OpenVario Recovery Tool" \
	--title "[ M A I N - M E N U ]" \
	--menu "You can use the UP/DOWN arrow keys" 15 50 6 \
	Flash_SDCard   "Write image to SD Card" \
	Reboot   "Reboot" \
	Power_OFF "Power OFF" \
	Exit "Exit to shell" 2>"${INPUT}"
	 
	menuitem=$(<"${INPUT}")
 
	# make decsion 
case $menuitem in
	Flash_SDCard) select_image;;
	Reboot) /opt/bin/reboot.sh;;
	Power_OFF) power_off;;
	Exit) ;;
esac

done
}

function select_image(){
	
	images=$DIRNAME/images/OpenVario-linux*.gz

	let i=0 # define counting variable
	files=() # define working array
	files_nice=()
	while read -r line; do # process file by file
		let i=$i+1
		files+=($i "$line")
		temp=$(echo $line | grep -oE '[0-9]{5}')
		temp2=$(echo $line | grep -o "testing")
		temp="$temp $temp2"
		files_nice+=($i "$temp")
	done < <( ls -1 $images )
	
	if [ -n "$files" ]
	then
		# Search for images
		FILE=$(dialog --backtitle "${TITLE}" \
		--title "Select image" \
		--menu "Use [UP/DOWN] keys to move, ENTER to select" \
		18 60 12 \
		"${files_nice[@]}" 3>&2 2>&1 1>&3) 
	else
		dialog --backtitle "${TITLE}" \
		--title "Select image" \
		--msgbox "\n\n No image file found !!" 10 40
		return
	fi
	IMAGEFILE=$(readlink -f $(ls -1 $images |sed -n "$FILE p"))
	
	# Show Image write options
	dialog --backtitle "${TITLE}" \
	--title "Select update method" \
	--menu "Use [UP/DOWN] keys to move, ENTER to select" \
	18 60 12 \
	"UpdateAll"	 "Update complete SD Card" \
	"UpdateuBoot"	 "Update Bootloader only" \
	2>"${INPUT}"
	
	menuitem=$(<"${INPUT}")
 
	# make decsion 
	case $menuitem in
		UpdateuBoot) updateuboot;;
		UpdateAll) updateall;;
	esac
	
}

#update rootfs on mmcblk0
function updaterootfs(){
		
	(pv -n ${IMAGEFILE} | gunzip -c | dd bs=1024 skip=1024 | dd of=$TARGET bs=1024 seek=1024) 2>&1 | dialog --gauge "Writing Image ... " 10 50 0
		
}

function notimplemented(){

	dialog --backtitle "${TITLE}" \
			--msgbox "Not implemented yet !!" 10 60
}

#update uboot
function updateuboot(){
		
	#gunzip -c $(cat selected_image.$$) | dd of=$TARGET bs=1024 count=1024	
	(pv -n ${IMAGEFILE} | gunzip -c | dd of=$TARGET bs=1024 count=1024) 2>&1 | dialog --gauge "Writing Image ... " 10 50 0
		
}

#update updateall
function updateall(){

	(pv -n ${IMAGEFILE} | gunzip -c | dd of=$TARGET bs=16M) 2>&1 | dialog --gauge "Writing Image ... " 10 50 0
}


function submenu_file() {

	### display file menu ###
	dialog --nocancel --backtitle "OpenVario" \
	--title "[ F I L E ]" \
	--begin 3 4 \
	--menu "You can use the UP/DOWN arrow keys" 15 50 4 \
	Download   "Download IGC File to USB" \
	Upload   "Upload files from USB to FC" \
	Back   "Back to Main" 2>"${INPUT}"
	
	menuitem=$(<"${INPUT}")
	
	# make decsion 
	case $menuitem in
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
	--menu "You can use the UP/DOWN arrow keys" 15 50 4 \
	Update_System   "Update system software" \
	Update_Maps   "Update Maps files" \
	Calibrate_Sensors   "Calibrate Sensors" \
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
		Exit) ;;
	esac		
}

function update_system() {
	echo "Updating System ..." > /tmp/tail.$$
	/usr/bin/update-system.sh >> /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function calibrate_sensors() {
	echo "Calibrating Sensors ..." >> /tmp/tail.$$
	systemctl stop sensord
	/opt/bin/sensorcal -c > /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
	systemctl start sensord
}

function update_maps() {
	echo "Updating Maps ..." > /tmp/tail.$$
	/usr/bin/update-maps.sh >> /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function download_files() {
	echo "Downloading files ..." > /tmp/tail.$$
	/usr/bin/download-igc.sh >> /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function upload_files(){
	echo "Uploading files ..." > /tmp/tail.$$
	/usr/bin/upload-all.sh >> /tmp/tail.$$ &
	dialog --backtitle "OpenVario" --title "Result" --tailbox /tmp/tail.$$ 30 50
}

function start_xcsoar() {
	/usr/bin/xcsoar_config.sh
	/opt/XCSoar/bin/xcsoar -fly -480x272
}

function power_off() {
	shutdown -h now
}

setfont cp866-8x14.psf.gz

main_menu
