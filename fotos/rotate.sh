#!/bin/bash

. `dirname "$0"`/includes.sh

args="imgdir"

# check arguments
check_arg "$1" "$args" "no image directory specified"

SIZE="800x800"

# basic assignments
DIR="$1"

for img in `ls "$DIR/" | grep -iE "jpe?g$"`; do
	action="0"

	echo $img" ..."

	# autorotate if Orientation field present in EXIF-Header
	jhead -autorot "$DIR/$img"

	while [ $action -lt 3 ]; do
		# display image
		convert -size $SIZE "$DIR/$img" -resize $SIZE +profile "*" "$DIR/rotate.jpg"
		if [ -z "`ps -fT | grep display | grep rotate`" ]; then
			display -geometry +0+0 -title "webAlbum: rotate" "$DIR/rotate.jpg" &
		else
			display -remote "$DIR/rotate.jpg"
		fi
		
		cat <<-EOF
		1) Rotate clockwise
		2) Rotate counter-clockwise
		3) Delete image
		4) Next image
		
		Option: [4]
		EOF
		read -n 1 action
		echo
		
		case $action in
			"1" )
				jpegtran -rotate 90 -copy all "$DIR/$img" > "$DIR/tmp.jpg"
				mv -f "$DIR/tmp.jpg" "$DIR/$img"
			;;
			"2" )
				jpegtran -rotate 270 -copy all "$DIR/$img" > "$DIR/tmp.jpg"
				mv -f "$DIR/tmp.jpg" "$DIR/$img"
			;;
			"3" )
				rm "$DIR/$img"
			;;
			* )
				# twiddle
				action=4
			;;
		esac
	done
done

# terminate display program
kill -TERM `ps -fT | grep display | grep rotate | awk '{print $2}'`
rm -f "$DIR/rotate.jpg"
