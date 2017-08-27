#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

EXCLUDES=(
	--include "`hostname`/"
	--exclude '/\*/'
)

if [ "`whoami`" = "root" ]; then
	if [ "$1" = "full" ]; then
		shift 1
		backup "backup/rsnapshot/daily.0/" $@
	else
		backup "backup/rsnapshot/daily.0/" $@ ${EXCLUDES[@]}
	fi
else
	for i in "$ORIG/backup/"*/; do
		path=${i##$ORIG}
		if [ "$path" = "/backup/rsnapshot/" ]; then
			continue
		fi
		backup "$path/" $@
	done

	header "re-run as root to backup system files"
fi

