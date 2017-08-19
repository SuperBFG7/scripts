#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

if [ "`whoami`" = "root" ]; then
	backup "backup/rsnapshot/daily.0/" $@
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

