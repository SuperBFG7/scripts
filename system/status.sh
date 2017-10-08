#!/bin/bash

. `dirname "$0"`/includes.sh

header "System Status"
systemctl status --no-pager
echo ""
if hash docker 2>/dev/null; then
	header "Docker Container Status"
	docker ps
fi

header "Failed Services" pause
systemctl --failed --no-pager

header "High Priority Errors in journal (since last boot and max. 1 week ago)" pause
#journalctl -b -p 0..3 -xn --no-pager -n 50 --since="1 week ago"
journalctl -b -p 3 -x --no-pager -S "7 days ago" | tail -50

header "Open ports and what process is listening on them" pause
netstat -apntu

header "Last logins" pause
last -adn 20
