#!/bin/bash

for i in *pdf; do
	echo "mv -i \"$i\" "
	evince "$i" &> /dev/null

	if [ -n "$1" ]; then
		rm -i "$i"
		echo
	fi
done
