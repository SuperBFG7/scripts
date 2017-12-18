#!/bin/bash

. `dirname "$0"`/includes.sh

args="sourcedir mp3dir [dryrun]"

# check arguments
check_arg "$1" "$args" "no source directory specified"
check_arg "$2" "$args" "no mp3 directory (target) specified"

# basic assignments
SRCDIR="$1"
MP3DIR="$2"
dryrun=$3

encode() {
	srcfile=$1
	
	# skip directories
	if [ -d "$srcfile" ]; then
		destdir="$MP3DIR/${srcfile##$SRCDIR}"
		if [ ! -d "$destdir" ]; then
			echo "creating dir  $destdir"
			if [ -z "$dryrun" ]; then
				mkdir -p "$destdir"
			fi
		fi
		return
	fi

	mp3file=`echo "$MP3DIR/${srcfile##$SRCDIR}" | sed -e "s/.[[:alpha:]]\+$/.mp3/"`

	# skip existing files, but re-encode newer
	if [ -f "$mp3file" ]; then
		if [ "$srcfile" -nt "$mp3file" ]; then
			echo "re-encoding file $mp3file"
			if [ ! -z "$dryrun" ]; then
				return
			fi
			rm "$mp3file"
		else
			echo "skipping file $mp3file"
			return
		fi
	fi
	echo "creating file $mp3file"

	if [ ! -z "$dryrun" ]; then
		return
	fi

	f=`echo "$srcfile" | sed -e "s/.*\.//"`
	case "$f" in
		"flac")
			# extract tags
			ARTIST=`metaflac "$srcfile" --show-tag=ARTIST | sed s/.*=//g`
			TITLE=`metaflac "$srcfile" --show-tag=TITLE | sed s/.*=//g`
			ALBUM=`metaflac "$srcfile" --show-tag=ALBUM | sed s/.*=//g`
			GENRE=`metaflac "$srcfile" --show-tag=GENRE | sed s/.*=//g`
			TRACKNUMBER=`metaflac "$srcfile" --show-tag=TRACKNUMBER | sed s/.*=//g`
			DATE=`metaflac "$srcfile" --show-tag=DATE | sed s/.*=//g | cut -b -4`

			# create mp3 file
			flac -cd "$srcfile" | lame --ignore-tag-errors \
				--ta "$ARTIST" --tt "$TITLE" --tl "$ALBUM" --tg "$GENRE" \
				--tn "$TRACKNUMBER" --ty "$DATE" - "$mp3file"
		;;
		"ogg")
			# extract tags
			ARTIST=`vorbiscomment -l "$srcfile" | grep  -iE "^ARTIST=" | sed s/.*=//g`
			TITLE=`vorbiscomment -l "$srcfile" | grep -iE "^TITLE=" | sed s/.*=//g`
			ALBUM=`vorbiscomment -l "$srcfile" | grep -iE "^ALBUM=" | sed s/.*=//g`
			GENRE=`vorbiscomment -l "$srcfile" | grep -iE "^GENRE=" | sed s/.*=//g`
			TRACKNUMBER=`vorbiscomment "$srcfile" | grep -iE "^TRACKNUMBER=" | sed s/.*=//g`
			DATE=`vorbiscomment "$srcfile" | grep -iE "^DATE=" | sed s/.*=//g | cut -b -4`

			# create mp3 file
			oggdec -o /dev/stdout "$srcfile" | lame --ignore-tag-errors \
				--ta "$ARTIST" --tt "$TITLE" --tl "$ALBUM" --tg "$GENRE" \
				--tn "$TRACKNUMBER" --ty "$DATE" - "$mp3file"
		;;
		"mp3")
			if [ ! -z "$f" ]; then
				cp -aL "$srcfile" "$mp3file"
			fi
		;;
		*)
			echo "UNKNOW FILE FORMAT"
			exit 1
		;;
	esac
}

iterate "$SRCDIR" "encode"

