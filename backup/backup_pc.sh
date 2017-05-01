#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

EXCLUDES=(
	--include "`hostname`/"
	--exclude '/\*/'
)

if [ "`whoami`" = "root" ]; then
	backup "backup/rsnapshot/daily.0/" $@ ${EXCLUDES[@]}
else
	for i in "$ORIG/backup/"*/; do
		if [ ${i##$ORIG} = "/backup/rsnapshot/" ]; then
			continue
		fi
		backup "${i##$ORIG/}" $@
	done

	header "re-run as root to backup system files"
fi

