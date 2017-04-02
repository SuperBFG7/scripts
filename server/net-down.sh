#!/bin/bash
ip addr flush dev "$1"
ip route flush dev "$1"
ip link set dev "$1" down
