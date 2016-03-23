#!/bin/bash

. `dirname "$0"`/includes.sh

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

		mpc search -f '"/var/lib/mpd/music/%file%"' artist "$artist" album "$album" | xargs $@
	done
}


album_playlist $@ | beets_delete


header "THE FOLLOWING FILES WILL BE DELETED"
album_playlist $@ | delete "ls -l"
header "REALLY DELETE THESE FILES? (Y, n)"
read i
i=${i:-y}
if [ "$i" != "y" ]; then
	exit 1
fi

album_playlist $@ | delete "rm -f"
