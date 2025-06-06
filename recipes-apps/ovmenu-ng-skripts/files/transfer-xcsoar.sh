#!/bin/sh

# Transfer script for Up/Downloadng data to usbstick

USB_PATH="/usb/usbstick/openvario/"
XCSOAR_PATH="/home/root/.xcsoar"

case "$(basename "$0")" in
	'download-all.sh')
		SRC_PATH="$XCSOAR_PATH"
		DEST_PATH="$USB_PATH/download/xcsoar"
		;;
	'upload-xcsoar.sh')
		SRC_PATH="$USB_PATH/upload/xcsoar"
		DEST_PATH="$XCSOAR_PATH"
		;;
	'upload-all.sh')
		SRC_PATH="$USB_PATH/upload"
		DEST_PATH="$XCSOAR_PATH"
		;;
	*)
		>&2 echo 'call as download-all.sh, upload-xcsoar.sh or upload-all.sh'
		exit 1
esac

if [ ! -d "$SRC_PATH" ] || [ ! -d "$DEST_PATH" ]; then
	>&2 echo "Source $SRC_PATH or destination path $DEST_PATH does not exist"
	exit 1
fi

if [ -z "$(find "$SRC_PATH" -type f | head -n 1 2>/dev/null)" ]; then
	echo 'No files found !!!'
else
  # We use -c here due to cubieboards not having an rtc clock
	if rsync -r -c --progress "${SRC_PATH}/" "$DEST_PATH/"; then
		echo 'All files transfered successfully.'
	else
		>&2 echo 'An error has occured!'
		exit 1
	fi
fi

# Sync the buffer to be sure data is on disk
sync
echo 'Done !!'
