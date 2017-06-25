#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

for i in "$ORIG/fotos/"*/; do
	backup "$i" $@
done

