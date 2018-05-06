#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

backup "video/" $@ \
	--exclude 'tv/' \
	--exclude 'tv.archiv/'
