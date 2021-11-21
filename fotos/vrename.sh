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
	if [ -z "$timestamp" ]; then
		echo "$i has no timestamp"
		continue
	fi
	$cmd "$i" "$timestamp.${i##*.}"
done

