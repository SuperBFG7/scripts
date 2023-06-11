#!/bin/bash

. "$(dirname "$0")/includes.sh"

header "removing unused orphan packages"
# shellcheck disable=SC2046
pacman -Rns $(/usr/bin/pacman -Qtdq)

header "cleaning package cache: old versions"
paccache -r

header "cleaning package cache: uninstalled packages"
paccache -ruk0

header "cleaning package cache: custom repo"
paccache -c /home/packages/ -r -k 1

