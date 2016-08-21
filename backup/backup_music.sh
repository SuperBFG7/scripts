#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

backup "music/band/" $@
backup "music/incoming/" $@
backup "music/library/" $@ --exclude "high/" --exclude "new/"
backup "music/lossless/flac/" $@
backup "music/lossless/flac.beets/" $@
backup "music/lossless/flac.beets.lossy/" $@
backup "music/lossy/" $@ --exclude "flac.beets/" --exclude "new.p2p"
backup "music/lossy/new.p2p/" $@

#backup "music/mp3.new/" $@
