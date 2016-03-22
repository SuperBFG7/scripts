#!/bin/bash

. `dirname "$0"`/includes.sh

beets ()
{
	while read i; do
		echo "beet modify new! $i"
		echo "beet move $i"
	done
}

album_playlist $@ | beets
