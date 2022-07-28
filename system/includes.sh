#!/bin/bash

. "$(git rev-parse --show-toplevel)/includes.sh"	#STRIP#

# pause and wait for keypress
function pause() {
	echo "press <ENTER> to continue"
	read -r
}

# print a header
function header() {
	if [ -n "$2" ]; then
		pause
	fi
	echo "------------------------------------------------------------------------------"
	echo " $1"
	echo "------------------------------------------------------------------------------"
}

function debug() {
	if [ -n "$DEBUG" ]; then
		echo "$(date --rfc-3339=seconds) -- " "$@"
	fi
}
