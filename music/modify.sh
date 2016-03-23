#!/bin/bash

. `dirname "$0"`/includes.sh

beets_modify ()
{
	while read i; do
		artist="`echo $i | artist`"
		album="`echo $i | album`"
		echo "beet modify new! artist:\"$artist\" album:\"$album\""
		echo "beet move artist:\"$artist\" album:\"$album\""
	done
}

album_playlist $@ | beets_modify
