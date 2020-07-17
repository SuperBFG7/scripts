#!/bin/bash

. `dirname "$0"`/includes.sh

args="imgdir"

# check arguments
check_arg "$1" "$args" "no image directory specified"

# basic assignments
DIR="$1"

# normalize filenames
echo "renaming files ..."
rename DSC dsc "$DIR/"*
rename IMG img "$DIR/"*
rename CR2 cr2 "$DIR/"*
rename JPG jpg "$DIR/"*
rename MOV mov "$DIR/"*

# autorotate images based on EXIF orientation flag
echo "autorotate jpg files ..."
jhead -autorot "$DIR/"*.jpg 2> /dev/null

# remove executable flag
chmod a-x "$DIR/"*.{cr2,jpg} 2> /dev/null

# set exif time to file modification time for files without exif header
echo "create missing exif headers ..."
for i in "$DIR/"*.jpg; do
	if [ -z "`jhead "$i" | grep 'Date/Time'`" ]; then
		jhead -mkexif -dsft "$i"
		exiftool -model="unknown" "$i"
	fi
done
