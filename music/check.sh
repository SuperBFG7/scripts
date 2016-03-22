#!/bin/bash

beets ()
{
	while read i; do
		artist=`echo "$i" | sed -e "s#.*/\([^/]\+\)/\([^/]\+\)/\?#\1#"`
		album=`echo "$i" | sed -e "s#.*/\([^/]\+\)/\([^/]\+\)/\?#\2#"`
		echo "mpc searchadd artist '$artist' album '$album'"
		echo "beet ls -f '\$format:\$bitrate - \$path' artist:'$artist' album:'$album'"
	done >> ~/ok.txt
}

dir=`find "$1" -mindepth 1 -type d`
if [ ! -z "$dir" ]; then
	echo "$dir" | beets
	exit
fi

find "$1" -type d | beets
