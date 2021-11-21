#!/bin/bash

. `dirname "$0"`/includes.sh

actions="replay previous next rename/rate delete"

now_playing() {
	echo "movie ${#played[@]}/$(( ${#played[@]} + ${#queue[@]} )) - $i"
	exiftool "$i"  | grep -iE "^((file|image) size|duration)"
}

filter="(mp4|mov)"

if [ "$1" = "x" ]; then
	vfilter="r[0-5]"
	shift
fi

if [ ! -z "$1" ]; then
#	queue=(*r[$1]*)
	queue=("$@")
else
	queue=(*)
fi
played=()

l=${#queue[@]}
for ((i=0;i<=$l;i++)); do
	x="`echo ${queue[$i]} | grep -iE $filter`"
	if [ ! -z "$vfilter" ]; then
		x="`echo $x | grep -iEv $vfilter`"
	fi
	if [ -z "$x" ]; then
		echo "skipping ${queue[$i]} ..."
		unset queue[$i]
		continue
	fi
done
queue=("${queue[@]}")

while (( ${#queue[@]} )); do
	i="${queue[0]}"
	queue=( "${queue[@]:1}" )
	played=("$i" "${played[@]}")

	now_playing
	mpv -really-quiet "$i"

	select a in $actions; do
		case $REPLY in
			"1")
				now_playing
				mpv -really-quiet "$i"
				;;
			"2")
				if [ ! -z "${played[1]}" ]; then
					queue=("$i" "${queue[@]}")
					played=("${played[@]:1}")
					i="${played[0]}"
					now_playing
					mpv -really-quiet "$i"
				else
					echo "no previous movie"
				fi
				;;
			"3")
				break
				;;
			"4")
				# get basename
				tmp=`basename "${i}"`
				# remove timestamp
				tmp="${tmp:17}"
				# remove extension
				tmp="${tmp%.*}"
				# remove leading _ (if it has a name already)
				tmp="${tmp/_/}"
				# remove trailing rating (if it has one)
				name="${tmp/_r[0-9]}"
				# get rating if there is one
				rating="${tmp/$name/}"
				# remove leading _ (if it has a name already)
				rating="${rating/_/}"
				if [ -z "$rating" ]; then
					rating="r2"
				fi

				echo -n "Enter new name [$name]: "
				read n
				if [ ! -z "$n" ]; then
					name="$n"
				fi

				echo -n "Enter new rating (0-5) [${rating:1}]: "
				read r
				if [ ! -z "$r" ]; then
					rating="r$r"
				fi

				f=`basename "${i}"`
				f="${f:0:17}_${name}_${rating}.${f##*.}"
				f="${f/__r/_r}"
				f=`dirname "${i}"`/${f/__/}
				if [ "$i" != "$f" ]; then
					mv -i "$i" "$f"
					played=("$f" "${played[@]:1}")
					break
				else
					echo "no change, not renaming"
				fi
				;;
			"5")
				rm -i "$i"
				played=("${played[@]:1}")
				break
				;;
			*)
				;;
		esac
	done
done
