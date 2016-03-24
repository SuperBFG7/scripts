#!/bin/sh

NAMESERVER=ns1.despite.ch
HOST=pi.despite.ch.
TSTAMP=`date --rfc-3339=ns`
TTL=60
KEY="${HOME}/.ddns.key"

WAN=`upnpc -s | grep ExternalIPAddress | sed 's/[^0-9\.]//g'`

/usr/bin/nsupdate -k "${KEY}" << _EOUPDATE_ >/dev/null
server ${NAMESERVER}
update delete ${HOST} A
update delete ${HOST} TXT
update add ${HOST} ${TTL} A ${WAN}
update add ${HOST} ${TTL} TXT "${TSTAMP}"
show
send
_EOUPDATE_
