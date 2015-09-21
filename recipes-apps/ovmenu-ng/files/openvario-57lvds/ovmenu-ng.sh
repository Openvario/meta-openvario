#!/bin/bash

#Config
TIMEOUT=3
INPUT=/tmp/menu.sh.$$

# trap and delete temp files
trap "rm $INPUT; exit" SIGHUP SIGINT SIGTERM

main_menu () {
while true
do
	### display main menu ###
	dialog --clear --nocancel --backtitle "OpenVario" \
	--title "[ M A I N - M E N U ]" \
	--menu "You can use the UP/DOWN arrow keys" 15 50 4 \
	XCSoar   "Displays date and time" \
	File   "Copys file to and from FC" \
	System   "Update, Settings, ..." \
	Exit   "Exit to the shell" 2>"${INPUT}"
	 
	menuitem=$(<"${INPUT}")
 
	# make decsion 
case $menuitem in
	XCSoar) start_xcsoar;;
	File) submenu_file;;
	System) submenu_system;;
	Exit) echo "Bye"; break;;
esac

done
}

function submenu_file() {

	### display file menu ###
	dialog --nocancel --backtitle "OpenVario" \
	--title "[ F I L E ]" \
	--menu "You can use the UP/DOWN arrow keys" 15 50 4 \
	Download   "Download IGC File to USB" \
	Upload   "Upload files form USB to FC" \
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
	dialog --backtitle "OpenVario" \
	--title "[ S Y S T E M ]" \
	--menu "You can use the UP/DOWN arrow keys" 15 50 4 \
	Update_System   "Update system software" \
	Update_Maps   "Update Maps files" \
	Calibrate_Sensors   "Calibrate Sensors" \
	Back   "Back to Main" 2>"${INPUT}"
	
	menuitem=$(<"${INPUT}")
	
	# make decsion 
	case $menuitem in
		Update_System) 
			out=$(/usr/bin/update-system.sh)
			dialog --backtitle "OpenVario" --title "Result" --msgbox "$out" 30 60
			;;
		Update_Maps) 
			out=$(/usr/bin/update-maps.sh)
			dialog --backtitle "OpenVario" --title "Result" --msgbox "$out" 30 60
			;;
		Calibrate_Sensors)  ;;
		Exit) ;;
	esac		
	
	

}

function download_files() {
	out=$(/usr/bin/download-igc.sh)
	dialog --backtitle "OpenVario" --title "Result" --msgbox "$out" 30 60
}

function upload_files(){
	out=$(/usr/bin/upload-all.sh)
	dialog --backtitle "OpenVario" --title "Result" --msgbox "$out" 30 60
}

function start_xcsoar() {
	/usr/bin/xcsoar_config.sh
	/opt/XCSoar/bin/xcsoar -fly -640x480
}


DIALOG_CANCEL=1 dialog --nook --nocancel --pause "Starting XCSoar ..." 10 30 $TIMEOUT 2>&1

case $? in
	0) start_xcsoar;;
	*) main_menu;;
esac