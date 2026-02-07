save_image() {
#    gzip -cfd ${IMAGEFILE} | dd of=$TARGET bs=1M count=20
#  tar cvf - /var/lib/connman | gzip >$RECOVER_DIR/connman.tar.gz
#  dd if=/dev/mmcblk0 of=${SDIMG} bs=1 count=0 seek=$(expr 1024 \* ${SDIMG_SIZE})
  mkdir -p $PARTITION3/backup
#  dd if=/dev/mmcblk0 of=$PARTITION3/backup/backup.img 
#  gzip -f $PARTITION3/backup/backup.img
  
  dd if=/dev/mmcblk0 | gzip > $PARTITION3/backup/backup.img.gz
  
  sync
  echo "Save current Image ready.."
  read -p "Press enter to continue"
}

load_image() {

}
