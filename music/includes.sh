#!/bin/bash

# get artist and album from mpd playlist
album_playlist ()
{
	if [ ! -z "$1" ]; then
		limit=$1
	else
		limit="1"
	fi

	mpc playlist -f 'artist:"%artist%" album:"%album%"' | uniq | head -n $limit
}

# get artist
artist ()
{
	sed -e 's/.*artist:"//' -e 's/".*//'
}

# get album
album ()
{
	sed -e 's/.*album:"//' -e 's/".*//'
}
