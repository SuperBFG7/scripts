#!/bin/bash

. `dirname "$0"`/includes.sh

args="imgdir [date]\n \
\t	  (default mode is comment)"

# check arguments
check_arg "$1" "$args" "no image directory specified"

# basic assignments
DIR="$1"
MODE="$2"

ls "$DIR/"*.{jpg,jpeg,heic,JPG,JPEG,HEIC} 2> /dev/null | while read img; do
	if [ -z "$MODE" ]; then
		name=`jhead "$img" | grep Comment | sed -e 's/.*: //'`
	else
#		name=`jhead "$img" | grep Date | sed -e 's/.*: //' -e 's/:/-/1' -e 's/:/-/1' -e 's/:/./g'`"_`basename $img`"
		name=`jhead "$img" | grep "Date/Time" | sed -e 's/.*: //' -e 's/://g' -e 's/ //g'`
		[ -n "$name" ] || name=`exiftool "$img" | grep "Date/Time Original" | grep -v "+" | sed -e 's/.*: //' -e 's/://g' -e 's/ //g'`
		name="${name}_`basename $img`"
	fi

	if [ -z "$name" -o "$name" = "_`basename $img`" ]; then
		echo "$img target name is empty, skipping rename..."
	else
		echo "$img  --> $name"
		mv -n "$img" "$DIR/$name"
	fi
done

exit 0

if [ ! -z "$MODE" ]; then
	echo "pushd \"$DIR\""
	echo "mkdir dropbox"
	echo 'for i in *jpg; do mv -i "~/dropbox/Kamera-Uploads/$i" dropbox/; done'
	echo 'jhead -autorot -purejpg *jpg'
	echo 'jhead -autorot -purejpg dropbox/*jpg'
	echo 'diff -r . dropbox/'
fi
