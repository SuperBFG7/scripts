#!/bin/bash

. `dirname "$0"`/includes.sh

beets_check ()
{
	while read i; do
		albumartist="`echo $i | albumartist`"
		album="`echo $i | album`"
		echo "mpc searchadd albumartist \"$albumartist\" album \"$album\""
		echo "beet ls -f '\$format:\$bitrate - \$path' albumartist:\"$albumartist\" album:\"$album\""
	done
}

if [ ! -z "$1" ]; then
	album_playlist $1 | beets_check
else
	eval "`album_playlist | beets_check`"
fi
