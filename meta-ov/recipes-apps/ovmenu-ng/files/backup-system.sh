#!/bin/sh

# Transfer script for backup to usbstick

USB_PATH=/usb/usbstick/openvario/backup

echo "
/etc/dropbear
/etc/odpk
/var/lib/...
" | grep -P -v "^[\t\n\r ]*$" | 
while read DIR
do
	echo "Path: $DIR"
	SRC_PATH="$DIR"
	DEST_PATH="$USB_PATH/$DIR"

	if [ ! -d "$SRC_PATH" ] || [ ! -d "$DEST_PATH" ]; then
		>&2 echo "Source $SRC_PATH or destination path $DEST_PATH does not exist"
		exit 1
	fi
	
	if [ -z "$(find "$SRC_PATH" -type f | head -n 1 2>/dev/null)" ]; then
		echo 'No files found !!!'
	fi
	
	# We use -c here due to cubieboards not having an rtc clock
#	if rsync -r -c --progress "$SRC_PATH/" "$DEST_PATH/"; then
	if rsync --dry-run -r -c --progress "$SRC_PATH/" "$DEST_PATH/"; then
		echo 'All files transfered successfully.'
	else
		EXIT=$?
		>&2 echo 'An error has occured!'
		exit $EXIT
	fi
done

# Sync the buffer to be sure data is on disk
sync
echo 'Done !!'
