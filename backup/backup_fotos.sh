#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

for i in "$ORIG/fotos/"*/; do
	backup "$i" $@ --delete-excluded \
		--exclude '/jpg.selections/' \
		--exclude '/jpg/[0-9]/' \
		--exclude '/jpg.low/[0-9]/' 
done

