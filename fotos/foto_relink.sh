#!/bin/bash

. `dirname "$0"`/includes.sh

args="albumdir (example: eos/2017-01-01_foo)"

# check arguments
check_arg "$1" "$args" "no album directory specified"

cameras="eos hugin ipad iphone"
src="${1#*/}"

for i in $cameras jpg jpg.low jpg.selections; do
	[ -e "$i" ] || die "$i does not exist; are you sure you are at the right directory?"
done

for i in 1 2 3 4 5 0; do
	if [ -e "jpg/$i/$src" ]; then
		header "jpg/$i/$src already exists, remove it first? (y/N)"
		read r
		if [ "$r" = "y" ]; then
			rm -fv jpg*/*/$src/*
			rmdir -v jpg*/*/$src/
		else
			die "jpg/$i/$src already exists, cannot continue"
		fi
		header "jpg/$i/$src removed, continuing ..."
		pause
	fi

	mkdir -p "jpg/$i/$src"
	mkdir -p "jpg.low/$i/$src"
	for c in $cameras; do
		for j in "$c/$src/jpg.export/"*"_r$i"*.jpg; do
			[ -f "$j" ] || continue
			f="`basename $j`"
			ln -rs "$j" "jpg/$i/$src/${c}_$f"
			ln -rs "$c/$src/jpg.low/$f" "jpg.low/$i/$src/${c}_$f"
		done

		[ "$c" = "eos" ] && continue
		for j in "$c/$src/jpg.low/"*"_r$i"*.jpg; do
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
	[ -e "jpg.selections/$q" ] && continue
	for s in 1_all 2_selected 3_best 4_verybest 5_portfolio x_private; do
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
		[ $i -eq 4 ] && continue
		ln -rs "$q/$i" "jpg.selections/$q/5_portfolio"
	done
	ln -rs "$q/0" "jpg.selections/$q/x_private"
done

for i in 1_all 2_selected 3_best 4_verybest; do
	stow_dir "jpg.selections/jpg/$i"
	stow_dir "jpg.selections/jpg.low/$i"
done

rm -f jpg.selections/jpg*/5_portfolio/all/*
rm -f jpg.selections/jpg*/x_private/all/*
ln -rs jpg.selections/jpg/5_portfolio/5/*/* jpg.selections/jpg/5_portfolio/all/
ln -rs jpg.selections/jpg.low/5_portfolio/5/*/* jpg.selections/jpg.low/5_portfolio/all/
ln -rs jpg.selections/jpg/x_private/0/*/* jpg.selections/jpg/x_private/all/
ln -rs jpg.selections/jpg.low/x_private/0/*/* jpg.selections/jpg.low/x_private/all/

