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

# backup root
header "/etc/"
echo run as root: rsync $@ ${RSYNC_OPTS[@]} "/etc/" "$BKP/backup/mustang/etc/"
