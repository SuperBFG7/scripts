#!/bin/bash

. `dirname "$0"`/includes.sh

args="user interval"

# check arguments
check_arg "$1" "$args" "no user specified"
check_arg "$2" "$args" "no rsnapshot interval specified"

(cat /etc/rsnapshot.conf | sed -e "s:/.snapshots/:/mnt/backup/$1/snapshots/:" -e "s/#no_create_root/no_create_root/" | grep -v "^backup" && echo "backup	/home/$1/	$1/") > /var/run/rsnapshot.conf

mount "/mnt/backup/$1"
rsnapshot -c /var/run/rsnapshot.conf "$2"
umount "/mnt/backup/$1"
rm /var/run/rsnapshot.conf
