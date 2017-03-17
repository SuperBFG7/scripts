#!/bin/bash

. `dirname "$0"`/includes.sh

beets_modify ()
{
	while read i; do
		albumartist="`echo $i | albumartist`"
		album="`echo $i | album`"
		echo "beet modify new! albumartist:\"$albumartist\" album:\"$album\""
		echo "beet move albumartist:\"$albumartist\" album:\"$album\""
	done
}

if [ ! -z "$2" ]; then
	album_playlist $1 | beets_modify
else
	eval "`album_playlist $1 | beets_modify`"
fi
