#!/bin/bash

. `dirname "$0"`/includes.sh

beets_check ()
{
	while read i; do
		artist="`echo $i | artist`"
		album="`echo $i | album`"
		echo "mpc searchadd artist \"$artist\" album \"$album\""
		echo "beet ls -f '\$format:\$bitrate - \$path' artist:\"$artist\" album:\"$album\""
	done
}

album_playlist $@ | beets_check
