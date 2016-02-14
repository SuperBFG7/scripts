#!/bin/bash

. `dirname "$0"`/includes.sh

header "System Status" off
systemctl status --no-pager
echo ""
header "Docker Container Status" off
docker ps

header "Failed Services"
systemctl --failed --no-pager

header "High Priority Errors in journal (since last boot and max. 1 week ago)"
#journalctl -b -p 0..3 -xn --no-pager -n 50 --since="1 week ago"
journalctl -b -p 3 -x --no-pager -S "7 days ago" | tail -50

header "Open ports and what process is listening on them"
netstat -apntu

header "Last logins"
last -adn 20
