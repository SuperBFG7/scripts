#!/bin/bash

. `dirname "$0"`/includes.sh

open(){
	cryptsetup open "$1" backup
	mount /dev/mapper/backup /mnt/backup/
	su - daniel -l
	umount /mnt/backup
	cryptsetup close backup
}

if [ ! "`whoami`" = "root" ]; then
	die "must be root to mount encrypted disk"
fi

for i in `ls /dev/sd[a-z]1`; do
	echo "testing $i ..."
	if [ ! -z "`cryptsetup isLuks "$i" && echo 'luks'`" ]; then
		echo "opening $i ..."
		open "$i"
	fi
done


