#!/bin/bash

. "$(dirname "$0")/includes.sh"

if hash pacmatic 2>/dev/null; then
	pacmatic "$@"
else
	echo "*** WARNING: pacmatic not found, using pacman instead ***"
	/usr/bin/pacman "$@"
fi

if [ "$1" != "-Syu" ]; then
	exit 0
fi

if hash pkgfile 2>/dev/null; then
	pkgfile -u
else
	echo "*** WARNING: pkgfile not found, skipping ***"
fi

systemctl daemon-reload

if ! hash aur 2>/dev/null; then
	echo "*** WARNING: aurutils not found, skipping AUR updates ***"
	exit 0
fi
header "checking AUR updates..."
aur repo --upgrades
aur repo -l | aur vercmp -a -u 2 | grep "<-" | sed -e "s/-$/is missing in AUR/"
