#!/bin/bash

# exit with a message
die() {
	cat <<-EOF
		$@
	EOF
	exit 1
}

# print script usage
usage() {
	echo -e "usage: $0 $@"
}

# check if argument is specified
check_arg() {
	if [ -z $1 ]; then
		usage $2
		die $3
	fi
}

