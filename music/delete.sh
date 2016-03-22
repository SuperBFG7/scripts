#!/bin/bash

beets ()
{
	while read i; do
		artist=`echo "$i" | sed -e "s#.*/\([^/]\+\)/\([^/]\+\)/\?#\1#"`
		album=`echo "$i" | sed -e "s#.*/\([^/]\+\)/\([^/]\+\)/\?#\2#"`
		echo "beet rm -d albumartist:'$artist' album:'$album'"
	done >> ~/ok.txt
}

find "$1"
echo "REALLY DELETE THESE FILES? (Y, n)"
read i
if [ "$i" = "n" ]; then
	exit 1
fi

dir=`find "$1" -mindepth 1 -type d`
if [ ! -z "$dir" ]; then
	echo "$dir" | beets
else
	find "$1" -type d | beets
fi
rm -rf "$1"
