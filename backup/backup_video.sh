#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

backup "video/" $@ \
	--exclude 'archiv' \
	--exclude 'tv/' \
	--exclude 'tv.archiv' \
	--exclude 'videoclips'

backup "video/archiv/" $@

backup "video/videoclips/" $@
