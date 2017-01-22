#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

OPTS=(
	-av	--progress --delete
)

EXCLUDES=(
	--delete-excluded
	--exclude 'lost+found/'
	--exclude '.cache/'
	--exclude '.dropbox.cache/'
	--exclude '.dropbox-dist/'
)

if [ "`whoami`" = "root" ]; then
	backup "backup/etc.mustang/" $@
	backup "backup/rsnapshot/daily.0/" $@
else
	backup "backup/home.daniel/" $@ ${EXCLUDES[@]}
	backup "backup/home.despite/" $@
	backup "backup/raid/" $@
	backup "backup/windows/" $@

	header "re-run as root to backup system files"
fi

