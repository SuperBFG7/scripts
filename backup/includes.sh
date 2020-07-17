#!/bin/bash

. `git rev-parse --show-toplevel`/includes.sh	#STRIP#

DATA="/data"
PI="/mnt/pi/data"
EXTERNAL="/mnt/external"
SECONDARY="/mnt/secondary"
BACKUP="/mnt/backup"
NAS="pi4:/data"
SERVER="despite:/home/daniel/backup"

SOURCES="$DATA $PI $NAS $EXTERNAL $SECONDARY"
TARGETS="$NAS $EXTERNAL $SERVER $BACKUP $SECONDARY"

RSYNC_OPTS="-av --progress --delete --exclude lost+found/"

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
	eval rsync $@ $RSYNC_OPTS "$src" "$dst"
}

backup () {
	# remove prefix
	rel_path="${1#$ORIG/}"
	shift 1
	backup2 $rel_path $rel_path $@
}

backup_exclude () {
	# skip excludes
	[[ $2 =~ $1 ]] && echo "skipping '$2' (excluded)" && return 0

	shift 1
	backup $@
}

