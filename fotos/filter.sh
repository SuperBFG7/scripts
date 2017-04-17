#!/bin/bash

. `dirname "$0"`/includes.sh

args="origdir filterdir [origext filterext]"

# check arguments
check_arg "$1" "$args" "no original directory specified"
check_arg "$2" "$args" "no filter directory specified"

ORIG="$1"
FILTER="$2"

if [ ! -z "$3" ]; then
	check_arg "$4" "$args" "no filter extension specified"
	OEXT="$3"
	FEXT="$4"
fi

mkdir -p "$ORIG/_filtered"

ls "$ORIG/"*.{jpg,cr2,nef,png,JPG,CR2,NEF,PNG} | while read img; do
	if [ ! -z "$OEXT" ]; then
		fimg=`echo $img | sed -e "s/$OEXT/$FEXT/"`
	else
		fimg=$img
	fi
	if [ -f "$FILTER/$fimg" ]; then
		echo -n "."
	else
		echo -n "x"
		mv -i "$ORIG/$img" "$ORIG/_filtered/"
	fi
done
echo
