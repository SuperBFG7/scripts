#!/bin/bash

. `dirname "$0"`/includes.sh

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

# cleanup
if [ ! -z "$1" ]; then
	header "unstowing all music directories"
	pause

	unstow_dir "/data/music/library/high"
	unstow_dir "/data/music/lossless/flac"
	unstow_dir "/data/music/lossless/flac.beets.lossy"
	unstow_dir "/data/music/lossy/ogg"
	unstow_dir "/data/music/lossy/ogg.beets"
	unstow_dir "/data/music/lossy/mp3/"
	unstow_dir "/data/music/lossy/mp3.beets/"
	unstow_dir "/data/music/lossy/aac.beets/"
	unstow_dir "/data/music/lossy/mpc.beets/"
	exit 0
fi

header "stowing all music directories"
pause

# stow flac
stow_dir "/data/music/lossless/flac"
stow_dir "/data/music/lossless/flac.beets.lossy"
# stow ogg
stow_dir "/data/music/lossy/ogg"
stow_dir "/data/music/lossy/ogg.beets"
# stow mp3
stow_dir "/data/music/lossy/mp3/"
stow_dir "/data/music/lossy/mp3.beets/"
# stow aac and musepack
stow_dir "/data/music/lossy/aac.beets/"
stow_dir "/data/music/lossy/mpc.beets/"

# stow library
stow_dir "/data/music/library/high"

echo
mpc stats
echo "updating mpd database ..."
mpc update

