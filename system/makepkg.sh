#!/bin/bash

. /etc/makepkg.conf

if ! /usr/bin/makepkg "$@"; then
	exit 1
fi
rm -f "$PKGDEST"/custom.db*
repo-add "$PKGDEST"/custom.db.tar.gz "$PKGDEST"/*.pkg.tar.*
