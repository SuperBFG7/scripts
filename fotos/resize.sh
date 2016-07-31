#!/bin/bash

. `dirname "$0"`/includes.sh

args="srcdir destdir [size]\
	  (default size is 1920x1080)"

# check arguments
check_arg "$1" "$args" "no source directory specified"
check_arg "$2" "$args" "no destination directory specified"

if [ ! -z "$3" ]; then
	SIZE=$3
else
	SIZE="1920x1080"
	echo "no size specified, using $SIZE"
fi

# basic assignments
ORIG="$1"
DEST="$2"

# create destination directory
mkdir -p "$ORIG"

ls "$ORIG/" | grep -iE "jpe?g$" | while read img; do
	echo $img" ..."

	# resize file
	convert -size $SIZE "$ORIG/$img" -resize $SIZE "$DEST/$img"
	# remove EXIF thumbnail and add original filename as JPEG comment
	jhead -dt -cl "$img" "$DEST/$img"
done
