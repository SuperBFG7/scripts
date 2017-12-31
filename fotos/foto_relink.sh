#!/bin/bash

. `dirname "$0"`/includes.sh

cameras="eos ipad iphone"
src="${1#*/}"

for i in $cameras jpg jpg.low jpg.selections; do
	[ -e "$i" ] || die "$i does not exist; are you sure you are at the right directory?"
done

for i in 1 2 3 4 5; do
	[ -e "jpg/$i/$src" ] && die "jpg/$i/$src already exists"

	mkdir -p "jpg/$i/$src"
	mkdir -p "jpg.low/$i/$src"
	for c in $cameras; do
		for j in "$c/$src/jpg.export/"*"_r$i.jpg"; do
			[ -f "$j" ] || continue
			f="`basename $j`"
			ln -rs "$j" "jpg/$i/$src/${c}_$f"
			ln -rs "$c/$src/jpg.low/$f" "jpg.low/$i/$src/${c}_$f"
		done

		[ "$c" = "eos" ] && continue
		for j in "$c/$src/jpg.low/"*"_r$i.jpg"; do
			[ -f "$j" ] || continue
			f="`basename $j`"
			ln -rs "$c/$src/jpg.low/$f" "jpg.low/$i/$src/${c}_$f"
			ln -rs "$c/$src/${f%_r*.jpg}.jpg" "jpg/$i/$src/${c}_$f"
		done
	done

	rename.sh jpg/$i/$src/ date
	rename.sh jpg.low/$i/$src/ date
done
rmdir --ignore-fail-on-non-empty jpg*/*/$src/

header "added album $src (not yet stowed)"
pause

for q in jpg jpg.low; do
	[ -e "jpg.selections/$q" ] || continue
	for s in 1_all 2_selected 3_best 4_verybest; do
		mkdir -p "jpg.selections/$q/$s/all"
	done

	for i in 1 2 3 4 5; do
		ln -rs "$q/$i" "jpg.selections/$q/1_all"
		[ $i -eq 1 ] && continue
		ln -rs "$q/$i" "jpg.selections/$q/2_selected"
		[ $i -eq 2 ] && continue
		ln -rs "$q/$i" "jpg.selections/$q/3_best"
		[ $i -eq 3 ] && continue
		ln -rs "$q/$i" "jpg.selections/$q/4_verybest"
	done
done

for i in 1_all 2_selected 3_best 4_verybest; do
	stow_dir "jpg.selections/jpg/$i"
	stow_dir "jpg.selections/jpg.low/$i"
done

