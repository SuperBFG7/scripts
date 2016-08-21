#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

RSYNC_OPTS=(
	-av	--progress --delete --delete-excluded
	--exclude 'lost+found/'
	--exclude '.cache/'
	--exclude '.dropbox.cache/'
	--exclude '.dropbox-dist/'
)

header "/data/raid/"
rsync $@ ${RSYNC_OPTS[@]} "/data/raid/" "$BKP/backup/raid/"

header "/home/daniel/"
rsync $@ ${RSYNC_OPTS[@]} "/home/daniel/" "$BKP/backup/home.daniel/"
# backup pi data
header "to backup pi data run:"
echo rsync $@ -av --progress --delete --rsh=ssh --exclude mustang/ --exclude rsnapshot/ pimedia:/data/backup/ $BKP/backup/

# backup root
header "to backup /etc/ run as root:"
echo rsync $@ ${RSYNC_OPTS[@]} "/etc/" "$BKP/backup/mustang/etc/"

# backup pi root
header "to backup pi root run as root:"
echo rsync $@ -av --progress --delete --delete-excluded --rsh=ssh --include /rsnapshot/ --include /rsnapshot/daily.0/ --exclude rsnapshot/*/ pi3:/data/backup/ $BKP/backup/
