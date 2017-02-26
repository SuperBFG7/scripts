#!/bin/bash

pacmatic $@

if [ "$1" != "-Syu" ]; then
	exit 0
fi

. `dirname "$0"`/includes.sh

if hash pkgfile 2>/dev/null; then
	pkgfile -u
fi
header "checking AUR updates..."
. /etc/makepkg.conf
repo="custom"
/usr/bin/pacman -Slp $repo | awk '{print $2}' | sort | \
		diff --changed-group-format='%<' --unchanged-group-format='' --label "" - $PKGDEST/ignore.txt | while read i; do
	local="`/usr/bin/pacman -Si $repo/$i | grep Version | sed -e "s/.* //"
	`"
	remote="`cower -s -b --format %v ^$i$`"

	if [ "$local" = "$remote" ]; then
		echo "$i is up to date"
	else
		echo "$i: $local --> $remote"
	fi
done
