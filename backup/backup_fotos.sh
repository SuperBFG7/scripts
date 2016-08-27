#!/bin/bash

. `dirname "$0"`/includes.sh

setup_backup

backup "fotos/Hochzeit/" $@
backup "fotos/jpg/" $@
backup "fotos/raw/" $@
backup "fotos/tif/" $@
backup "fotos/TODO/" $@
backup "fotos/video/" $@
