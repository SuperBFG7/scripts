#!/bin/bash

. `dirname "$0"`/includes.sh

args="imgdir"

# check arguments
check_arg "$1" "$args" "no image directory specified"

# basic assignments
DIR="$1"

ls "$ORIG/" | grep -iE "jpe?g$" | while read img; do
	name=`jhead "$i" | grep Comment | sed -e 's/.*: //'`

	echo "$img  --> $name"
	echo mv -i "$img" "$name"
done
