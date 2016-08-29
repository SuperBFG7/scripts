#!/bin/bash

. `git rev-parse --show-toplevel`/includes.sh	#STRIP#

DATA="/data"
PI="/mnt/pi"
EXTERNAL="/mnt/external"
BACKUP="/mnt/backup"
NAS="pi3:/data"
SERVER="despite:/home/daniel/backup"

SOURCES="$DATA $PI $NAS $EXTERNAL"
TARGETS="$NAS $EXTERNAL $SERVER $BACKUP"

RSYNC_OPTS="-av --progress --delete --exclude all/ --exclude lost+found/"

setup_backup() {
	header "select source"
	select i in $SOURCES; do
		ORIG=$i
		break
	done
	i=""

	header "select destination"
	select i in $TARGETS; do
		BKP=$i
		break
	done
}

backup2() {
	src="$ORIG/$1"
	dst="$BKP/$2"
	shift 2

	if [ -z "`echo $src | grep -E '^[^/]*:'`" -a ! -e "$src" ]; then
		echo "skipping '$src' (does not exist)"
		return 0
	fi

	header "'$src' --> '$dst'"
	rsync $@ $RSYNC_OPTS "$src" "$dst"
}

backup () {
	backup2 $1 $@
}

