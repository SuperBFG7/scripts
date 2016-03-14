#!/bin/bash

function pause() {
	echo "press <ENTER> to continue"
	read
}

function header() {
	if [ ! -z "$2" ]; then
		pause
	fi
	echo "------------------------------------------------------------------------------"
	echo " " $1
	echo "------------------------------------------------------------------------------"
}
