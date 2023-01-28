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
rename HEIC heic "$DIR/"*
rename JPG jpg "$DIR/"*
rename PNG png "$DIR/"*
rename MOV mov "$DIR/"*
rename MP4 mp4 "$DIR/"*

# autorotate images based on EXIF orientation flag
echo "autorotate jpg files ..."
jhead -autorot "$DIR/"*.jpg 2> /dev/null

# remove executable flag
chmod a-x "$DIR/"*.{cr2,jpg,tif,png} 2> /dev/null

# set exif time to file modification time for files without exif header
echo "create missing exif headers ..."
for i in "$DIR/"*.jpg; do
	[ -f "$i" ] || exit
	if [ -z "`jhead "$i" | grep 'Date/Time'`" ]; then
		jhead -mkexif -dsft "$i"
		exiftool -model="unknown" "$i"
	fi
done

# compress TIFF images (lossless with ZIP compression)
for i in "$DIR/"*.tif; do
	[ -f "$i" ] || exit
	if [ -z "$(exiftool $i | grep 'Compression' | grep 'Adobe Deflate')" ]; then
		mv -iv "$i" "${i}_original"
		convert -monitor -compress ZIP "${i}_original" "$i"
	fi
done
