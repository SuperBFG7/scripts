#!/bin/bash

pacmatic $@

if [ "$1" != "-Syu" ]; then
	exit 0
fi

echo
echo "checking AUR updates..."
. /etc/makepkg.conf
repo="custom"
/usr/bin/pacman -Slp $repo | awk '{print $2}' | sort | \
		diff --changed-group-format='%<' --unchanged-group-format='' --label "" - $PKGDEST/ignore.txt | while read i; do
	local="`/usr/bin/pacman -Sp --print-format %v $repo/$i`"
	remote="`cower -s -b --format %v ^$i$`"

	if [ "$local" = "$remote" ]; then
		echo "$i is up to date"
	else
		echo "$i: $local --> $remote"
	fi
done
