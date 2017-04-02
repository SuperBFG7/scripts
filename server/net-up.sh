#!/bin/bash

#. /etc/conf.d/net-conf-enp3s0

ip link set dev "$1" up
ip addr add ${address}/${netmask} broadcast ${broadcast} dev "$1"
for i in ${address6}; do
	ip addr add ${i}/${netmask6} dev "$1"
done

[[ -z ${gateway} ]] || { 
  ip route add default via ${gateway}
}

[[ -z ${gateway6} ]] || { 
  ip route add default via ${gateway6} dev "$1"
}
