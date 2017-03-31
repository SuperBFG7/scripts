#!/bin/bash

. `git rev-parse --show-toplevel`/includes.sh	#STRIP#

# get albumartist and album from mpd playlist
album_playlist ()
{
	if [ ! -z "$1" ]; then
		limit=$1
	else
		limit="-0"
	fi

	mpc playlist -f 'albumartist:"%albumartist%" album:"%album%"' | uniq | head -n $limit
}

# get albumartist
albumartist ()
{
	sed -e 's/.*albumartist:"//' -e 's/".*//'
}

# get album
album ()
{
	sed -e 's/.*album:"//' -e 's/".*//'
}
