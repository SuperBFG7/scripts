#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

EXCLUDE="library|new|shared|rip|iTunes"
for i in "$ORIG/music/"*/; do
	backup_exclude $EXCLUDE $i $@
done

for i in "$ORIG/music/_new/"*/; do
	backup_exclude "zz_" $i $@
done

backup "music/library/" $@ --exclude "high/" --exclude "new/"
