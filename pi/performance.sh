#!/bin/bash

if [ "$1" != "performance" ] && [ "$1" != "ondemand" ]; then
	echo "usage: $0 performance|ondemand"
	echo
	echo "current CPU governor:"
	cat /sys/devices/system/cpu/*/cpufreq/scaling_governor
	exit 1
fi

for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
	echo -n "$cpu - old value: "
	cat $cpu/cpufreq/scaling_governor

	echo -n $1 | tee $cpu/cpufreq/scaling_governor
	echo
done | logger
