#/bin/bash

. `dirname "$0"`/includes.sh

cmd="echo mv -iv"
level="$1"
action="$2"

if [ -z "$level" ]; then
	usage "level [action]"
	echo "levels:"
	echo " safe    = only consider files with exif timestamps"
	echo " unsafe1 = only consider files missing exif timestamp and use modification date instead"
	echo
	echo "actions:"
	echo " dry = do nothing, display suggested renames (default)"
	echo " wet = perform the renames"
	exit 0
fi

if [ "$action" = "dry" ]; then
	cmd="mv -iv"
fi

for i in *.{mp4,mov}; do
	if [ ! -f "$i" ]; then
		continue
	fi
	type="safe"
	timestamp=`exiftool "$i" | grep -i "Date/Time Original" | head -1 | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g" | head -1`
	if [ -z "$timestamp" ]; then
		timestamp=`exiftool "$i" | grep -i "Creation Date" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g" | head -1`
	fi
	if [ -z "$timestamp" ]; then
		timestamp=`exiftool "$i" | grep -i "Media Create Date" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g" | head -1`
	fi
	if [ "$timestamp" = "0000-00-00_000000" ]; then
		type="unsafe"
		timestamp=`exiftool "$i" | grep -i "File Modification Date/Time" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g" | head -1`
	fi
	if [ -z "$timestamp" ]; then
		echo "# $i: no timestamp found, skipping"
		continue
	fi

	if [ "$level" != "$type" ]; then
		echo "# skipping $i - wrong level"
		continue
	fi

	$cmd "$i" "$timestamp.${i##*.}"
done

