#!/bin/bash

. `dirname "$0"`/includes.sh

args="origdir filterdir"

# check arguments
check_arg "$1" "$args" "no original directory specified"
check_arg "$2" "$args" "no filter directory specified"

ORIG="$1"
FILTER="$2"

mkdir -p "$ORIG/_filtered"

ls "$ORIG/" | grep -iE "jpg|cr2|png$" | while read img; do
	if [ -f "$FILTER/$img" ]; then
		echo -n "."
	else
		echo -n "x"
		mv -i "$ORIG/$img" "$ORIG/_filtered/"
	fi
done
echo
