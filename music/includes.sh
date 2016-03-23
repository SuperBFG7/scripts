#!/bin/bash

album_playlist ()
{
	if [ ! -z "$1" ]; then
		limit=$1
	else
		limit="1"
	fi

	mpc playlist -f 'artist:"%artist%" album:"%album%"' | uniq | head -n $limit
}

artist ()
{
	sed -e 's/.*artist:"//' -e 's/".*//'
}

album ()
{
	sed -e 's/.*album:"//' -e 's/".*//'
}
