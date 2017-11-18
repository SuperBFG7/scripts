#!/bin/bash

. `dirname "$0"`/includes.sh

if hash pacmatic 2>/dev/null; then
	pacmatic $@
else
	echo "*** WARNING: pacmatic not found, using pacman instead ***"
	/usr/bin/pacman $@
fi

if [ "$1" != "-Syu" ]; then
	exit 0
fi

if hash pkgfile 2>/dev/null; then
	pkgfile -u
else
	echo "*** WARNING: pkgfile not found, skipping ***"
fi
if ! hash cower 2>/dev/null; then
	echo "*** WARNING: cower not found, skipping AUR updates ***"
	exit 0
fi
systemctl daemon-reload
header "checking AUR updates..."
. /etc/makepkg.conf
repo="custom"
/usr/bin/pacman -Slp $repo | awk '{print $2}' | sort | \
		diff --changed-group-format='%<' --unchanged-group-format='' --label "" - $PKGDEST/ignore.txt | while read i; do
	local="`/usr/bin/pacman -Si $repo/$i | grep Version | sed -e "s/.* //"
	`"
	remote="`cower -s --format %v ^$i$`"

	if [ "$local" = "$remote" ]; then
		echo "$i is up to date"
	else
		echo "$i: $local --> $remote"
	fi
done
