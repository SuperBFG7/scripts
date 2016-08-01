#!/bin/bash

. `dirname "$0"`/includes.sh

args="imgdir [date]\n \
\t	  (default mode is comment)"

# check arguments
check_arg "$1" "$args" "no image directory specified"

# basic assignments
DIR="$1"
MODE="$2"

ls "$DIR/" | grep -iE "jpe?g$" | while read img; do
	if [ -z "$MODE" ]; then
		name=`jhead "$DIR/$img" | grep Comment | sed -e 's/.*: //'`
	else
		name=`jhead "$DIR/$img" | grep Date | sed -e 's/.*: //' -e 's/:/-/1' -e 's/:/-/1' -e 's/:/./g'`".jpg"
	fi

	echo "$img  --> $name"
	mv -n "$DIR/$img" "$DIR/$name"
done

if [ ! -z "$MODE" ]; then
	echo "pushd \"$DIR\""
	echo "mkdir dropbox"
	echo 'for i in *jpg; do mv -i "~/dropbox/Kamera-Uploads/$i" dropbox/; done'
	echo 'jhead -autorot -purejpg *jpg'
	echo 'jhead -autorot -purejpg dropbox/*jpg'
	echo 'diff -r . dropbox/'
fi
