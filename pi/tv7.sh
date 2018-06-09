#!/bin/bash

HOST=pi3
PORT=4022

wget -O - https://api.init7.net/tvchannels.m3u | sed -e "s#udp://@#http://$HOST:$PORT/udp/#"
