#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

EXCLUDES=(
	--delete-excluded
	--exclude 'lost+found/'
	--exclude '.cache/'
	--exclude '.dropbox.cache/'
	--exclude '.dropbox-dist/'
	--exclude '.git/objects/'
)

if [ "`whoami`" = "root" ]; then
	for i in "$ORIG/backup/etc."*/; do
		j=`echo $i | sed -e "s:^$ORIG/::"`
		backup "$j" $@
	done
	backup "backup/rsnapshot/daily.0/" $@
else
	for i in "$ORIG/backup/"*/; do
		j=`echo $i | sed -e "s:^$ORIG/::"`
		filtered=`echo $i | grep -E "/etc."`
		if [ ! -z "$filtered" ]; then
			continue
		fi
		backup "$j" $@ ${EXCLUDES[@]}
	done

	header "re-run as root to backup system files"
fi

