#!/bin/bash

. `dirname "$0"`/includes.sh

args="dir1 dir2 [ext1 ext2]"

# check arguments
check_arg "$1" "$args" "no directory1 specified"
check_arg "$2" "$args" "no directory2 specified"

DIR1="$1"
DIR2="$2"

if [ ! -z "$3" ]; then
	check_arg "$4" "$args" "no extension2 specified"
	EXT1="$3"
	EXT2="$4"
fi

diff <(cd "$DIR1"; find | sort | sed -e "s/$EXT1$/$EXT2/") \
	 <(cd "$DIR2"; find | sort) | sed -e "s/<\(.*\)$EXT2$/<\1$EXT1/"

