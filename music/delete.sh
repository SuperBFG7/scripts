#!/bin/bash

. `dirname "$0"`/includes.sh

MPD_DIR="/var/lib/mpd/music"

beets_delete ()
{
	while read i; do
		artist="`echo $i | artist`"
		album="`echo $i | album`"
		echo "beet rm -d albumartist:\"$artist\" album:\"$album\""
	done
}

delete ()
{
	while read i; do
		artist="`echo $i | artist`"
		album="`echo $i | album`"

		mpc search -f "\"$MPD_DIR/%file%\"" artist "$artist" album "$album" | xargs $@
	done
}


if [ ! -z "$2" ]; then
	album_playlist $1 | beets_delete
else
	eval "`album_playlist $1 | beets_delete`"
fi

if [ -d $MPD_DIR ]; then
	header "THE FOLLOWING FILES WILL BE DELETED" > /dev/stderr
	album_playlist $@ | delete "ls -l" > /dev/stderr
	header "REALLY DELETE THESE FILES? (Y, n)" > /dev/stderr
	read i
	i=${i:-y}
	if [ "$i" != "y" ]; then
		exit 1
	fi

	album_playlist $@ | delete "rm -f"
fi
