#! /bin/sh
#
# Automatically rotate video in mplayer based on EXIF tags
# based on https://ygrek.org/p/code/mplayer_autorotate
# (added support for multiple files given add once)

args=()

while (( "$#" )); do
	f="$1"
	shift
	if [ ! -f "$f" ]; then
		args+=( "$f" )
		continue
	fi

	case $(exiftool -rotation -b "$f") in
		90) rot="-vf rotate=1" ;;
		180) rot="-vf flip,mirror" ;;
		270) rot="-vf rotate=2" ;;
		*) rot="" ;;
	esac

	mplayer -use-filename-title ${args[@]} $rot "$f"
done

