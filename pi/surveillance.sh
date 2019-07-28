#!/bin/bash

if [ ! -f `dirname "$0"`/includes.sh ]; then
	function debug () {
		echo $@
	}
else
	. `dirname "$0"`/includes.sh
fi

# IPs to check for availability
IP="192.168.1.1 192.168.1.2 192.168.1.3"
# motion URL
MOTION_URL="http://motioneye:7999/1/detection"
#DEBUG=yes

# get previous presence status
PRESENCE_STATUS=$(< /tmp/presence_status.txt)

# valud arguments: status start pause
function motion_control () {
	wget -q -O - "$MOTION_URL/$1" | grep Camera | sed -e "s/<[^>]*>//g" -e "s/.*Camera/Camera/"
}

function mobile_presence () {
	# ping mobile to wake/fill arp cache
	ping -c 1 "$1" &> /dev/null
	# check if arp cache contains MAC or not (incomplete)
	arp -an | grep "$1" | grep -v "incomplete" &> /dev/null
	return $?
}

function presence () {
	for i in $IP; do
		if mobile_presence "$i"; then
			debug "$i is online"
			if [ ! "$PRESENCE_STATUS" = "online" ]; then
				logger "device $i is online, pausing motion detection"
				motion_control pause
				echo "online" > /tmp/presence_status.txt
			fi
			return 0
		else
			debug "$i is offline"
		fi
	done
	return 1
}

case "$1" in
	"status")
		motion_control "status"
	;;
	"start")
		motion_control "start"
	;;
	"pause")
		motion_control "pause"
	;;
	*)
		if ! presence; then
			debug "$IP appear to be offline... retrying in 30s..."
			if presence; then
				exit 0
			fi
			debug "$IP is/are offline"
			if [ ! "$PRESENCE_STATUS" = "offline" ]; then
				logger "no device is online, starting motion detection"
				motion_control start
				echo "offline" > /tmp/presence_status.txt
			fi
		fi
	;;
esac
