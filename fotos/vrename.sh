#/bin/bash

. `dirname "$0"`/includes.sh

cmd="echo mv -i"

if [ -z "$1" ]; then
	cmd="mv -i"
fi

for i in *.{mp4,mov}; do
	if [ ! -f "$i" ]; then
		continue
	fi
	timestamp=`exiftool "$i" | grep -i "Date/Time Original" | head -1 | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g"`
	if [ -z "$timestamp" ]; then
		timestamp=`exiftool "$i" | grep -i "Creation Date" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g"`
	fi
	if [ -z "$timestamp" ]; then
		timestamp=`exiftool "$i" | grep -i "Media Create Date" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g"`
	fi
	if [ "$timestamp" = "0000-00-00_000000" ]; then
		echo "$i: timestamp empty, using file modification date - PLEASE CHECK"
		timestamp=`exiftool "$i" | grep -i "File Modification Date/Time" | sed -e "s/.* : //" -e "s/[Z+].*//" -e "s/:/-/" -e "s/:/-/" -e "s/ /_/" -e "s/://g"`
	fi
	if [ -z "$timestamp" ]; then
		echo "$i: no timestamp found, skipping"
		continue
	fi
	$cmd "$i" "$timestamp.${i##*.}"
done

