#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

for i in "$ORIG/fotos/"*/; do
	j=`echo $i | sed -e "s:^$ORIG/::"`
	backup "$j" $@
done

