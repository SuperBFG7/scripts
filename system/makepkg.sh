#!/bin/bash

. /etc/makepkg.conf

/usr/bin/makepkg $@
if [ "$?" != "0" ]; then
	exit 1
fi
rm -f $PKGDEST/custom.db*
repo-add $PKGDEST/custom.db.tar.gz $PKGDEST/*.pkg.tar.xz
