#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

EXCLUDE="library|new|shared"

for i in "$ORIG/music/"*/; do
	j=`echo $i | sed -e "s:^$ORIG/::"`
	filtered=`echo $i | grep -E "$EXCLUDE"`
	if [ ! -z "$filtered" ]; then
		continue
	fi
	backup "$j" $@
done

EXCLUDE="zz_"

for i in "$ORIG/music/_new/"*/; do
	j=`echo $i | sed -e "s:^$ORIG/::"`
	filtered=`echo $i | grep -E "$EXCLUDE"`
	if [ ! -z "$filtered" ]; then
		continue
	fi
	backup "$j" $@
done

backup "music/library/" $@ --exclude "high/" --exclude "new/"
