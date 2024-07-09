#/bin/bash

. `dirname "$0"`/includes.sh

cmd="echo -n mv -iv"
hint="echo -e"
level="$1"
action="$2"

if [ -z "$level" ]; then
	level="all"
fi

case $level in
	"all" | "safe" | "unsafe") ;;
	*)
		usage "level [action]"
		echo "levels:"
		echo " safe   = only consider files with exif timestamps"
		echo " unsafe = only consider files missing exif timestamp and use modification date instead"
		echo " all    = consider all files, safe and unsafe (default)"
		echo
		echo "actions:"
		echo " dry  = do nothing, display suggested renames (default)"
		echo " wet  = perform the renames"
		echo " exif = set the EXIF CreateDate based on the filename"
		exit 0
		;;
esac

if [ "$action" = "wet" ]; then
	cmd="mv -iv"
	hint="true"
fi

for i in *.{mp4,mov,avi}; do
	if [ ! -f "$i" ]; then
		continue
	fi
	type="safe"
	timestamp=`exiftool "$i" | grep -i "^Date/Time Original" | head -1 | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g" | head -1`
	if [ -z "$timestamp" ]; then
		timestamp=`exiftool "$i" | grep -i "^Creation Date" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g" | head -1`
	fi
	if [ -z "$timestamp" ]; then
		timestamp=`exiftool "$i" | grep -i "^Create Date" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g" | head -1`
	fi
	if [ -z "$timestamp" ]; then
		timestamp=`exiftool "$i" | grep -i "^Media Create Date" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g" | head -1`
	fi
	if [ "$timestamp" = "0000-00-00_000000" ]; then
		type="unsafe"
		timestamp=`exiftool "$i" | grep -i "File Modification Date/Time" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g" | head -1`
	fi
	if [ -z "$timestamp" ]; then
		type="unsafe"
		timestamp=`date -r "$i" +%Y-%m-%d_%H%M%S`
	fi
	if [ -z "$timestamp" ]; then
		echo "# $i: no timestamp found, skipping"
		continue
	fi

	if [ "$level" != "all" -a "$level" != "$type" ]; then
		echo "# skipping $i - wrong level"
		continue
	fi

	if [ "$action" = "exif" ]; then
		echo "setting EXIF CreateDate based on filename for ${i}"
		exiftool -api QuickTimeUTC "-CreateDate<Filename" "${i}"
	fi

	$cmd "$i" "$timestamp.${i##*.}"
	$hint "\t # $type"
done

