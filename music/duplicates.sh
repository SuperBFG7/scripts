#!/bin/bash

. `dirname "$0"`/includes.sh

check ()
{
	while read i; do
		artist=`echo "$i" | sed -e "s#.*/\([^/]\+\)/\([^/]\+\)/\?#\1#"`
		album=`echo "$i" | sed -e "s#.*/\([^/]\+\)/\([^/]\+\)/\?#\2#"`
		[[ $album = *[* ]] || continue
		album=`echo "$album" | sed -e "s: \[.*::"`
		echo mpc searchadd artist \"$artist\" album \"$album\"
		echo ls -lh \"$i\"
		echo "beet ls -f '\$format:\$bitrate - \$path' artist:'$artist' album:'$album'"
	done
	beet duplicates -a -f 'mpc searchadd artist "$albumartist" album "$album"'
	beet duplicates -a -F -f 'ls -lh "$path"'
	beet duplicates -a -F -f "beet ls -f '\$format:\$bitrate - PATH' artist:'\$albumartist' album:'\$album'" | sed -e "s/PATH/\$path/"
}

beet ls -p -a | grep "\[" | check | sort | uniq

beet ls -p -a | sed -e "s#.*/\([^/]\+\)/\([^/]\+\)/\?#\1/\2#" | tr -cd '[:alnum:]/\n' | tr '[:upper:]' '[:lower:]' | sort | uniq -d
