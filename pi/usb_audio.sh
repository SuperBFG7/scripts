#!/bin/bash

if [ "$1" = "on" ]; then
	sleep 5

	(
		echo -n "current audio device: "
		wget -q -O - --header "Content-type: application/json" \
			--post-data '{"jsonrpc":"2.0","method":"Settings.GetSettingValue", "params":{"setting":"audiooutput.audiodevice"},"id":1}' \
			 http://localhost:8080/jsonrpc
	) | logger

	(
		echo -n "setting audio device: "
		wget -q -O - --header "Content-type: application/json" \
			--post-data '{"jsonrpc":"2.0","method":"Settings.SetSettingValue", "params":{"setting":"audiooutput.audiodevice","value":"ALSA:@:CARD=P20,DEV=0"},"id":1}' \
			http://localhost:8080/jsonrpc
	) | logger

	(
		echo -n "current audio device: "
		wget -q -O - --header "Content-type: application/json" \
			--post-data '{"jsonrpc":"2.0","method":"Settings.GetSettingValue", "params":{"setting":"audiooutput.audiodevice"},"id":1}' \
			 http://localhost:8080/jsonrpc
	) | logger

	logger "enabling mpd USB output"
	mpc enable 1

	logger "enabling performance mode for all CPU"
	performance.sh performance
else
#	logger "spinning down harddrives"
#	hdparm -y /dev/sd*

	(
		echo -n "setting audio device: "
		wget -q -O - --header "Content-type: application/json" \
			--post-data '{"jsonrpc":"2.0","method":"Settings.SetSettingValue", "params":{"setting":"audiooutput.audiodevice","value":"ALSA:null"},"id":1}' \
			http://localhost:8080/jsonrpc
	) | logger


	logger "disabling mpd USB output"
	mpc disable 1

	logger "disabling performance mode for all CPU"
	performance.sh ondemand
fi
