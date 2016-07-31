#!/bin/bash

# pause and wait for keypress
function pause() {
	echo "press <ENTER> to continue"
	read
}

# print a header
function header() {
	if [ ! -z "$2" ]; then
		pause
	fi
	echo "------------------------------------------------------------------------------"
	echo " " $1
	echo "------------------------------------------------------------------------------"
}
