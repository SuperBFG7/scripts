#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

backup "video/tv/" $@
backup2 "video/new/tv/" "video/tv.new/" $@

