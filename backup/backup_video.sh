#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

backup "video/" $@ \
	--exclude 'movies.incoming/' \
	--exclude 'queue/' \
	--exclude 'sickrage/' \
	--exclude 'sickrage.movies/' \
	--exclude 'tv/'

backup2 "video/new/sickrage/movies/" "video/sickrage.movies/" $@
