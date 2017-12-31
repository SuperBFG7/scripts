#!/bin/bash

. `dirname "$0"`/includes.sh

MUSIC_ROOT="${1:-/data/music}"

# cleanup
if [ ! -z "$1" ]; then
	header "unstowing all music directories"
	pause

	unstow_dir "/data/music/library/high"
	for i in "/data/music/"*.beets; do
		unstow_dir "$i"
	done
	exit 0
fi

header "stowing all music directories in $MUSIC_ROOT"
pause

# stow music dirs
for i in "$MUSIC_ROOT/"*.beets; do
	stow_dir "$i"
done

# stow library
stow_dir "$MUSIC_ROOT/library/high"

if hash mpc 2>/dev/null; then
	echo
	mpc stats
	echo "updating mpd database ..."
	mpc update
fi
