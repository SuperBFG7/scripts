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

# loop over a specified directory
iterate() {
	src=$1
	action=$2
	prefix=$3

#	echo
#	echo "entering directory $prefix"`basename "$src"`

	ls -d "$src/"* 2> /dev/null | while read i; do
		$action "$i" || exit 1
		if [ -d "$i" ]; then
			iterate "$i" "$action" "$src/" || exit 1
		fi
	done || die "FAILED to iterate"

#	echo "leaving directory $prefix"`basename "$src"`
}

stow_dir(){
	basedir="$1"

	header "stowing $basedir"
	
	ls "$basedir" | grep -Ev "^(all|block|good|new)$" | while read i; do
		stow -v -R -d "$basedir" -t "$basedir/all" "$i" || die "stow failed!"
	done || die "stow failed!"
}

unstow_dir(){
	basedir="$1"

	header "unstowing $basedir"
	
	ls "$basedir" | grep -Ev "^(all|block|good|new)$" | while read i; do
		stow -v -D -d "$basedir" -t "$basedir/all" "$i" || die "stow failed!"
	done || die "stow failed!"
}

