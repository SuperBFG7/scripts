#!/bin/bash

. `dirname "$0"`/includes.sh

header "removing unused orphan packages" off
pacman -Rns $(/usr/bin/pacman -Qtdq)

header "cleaning package cache: old versions" off
paccache -r

header "cleaning package cache: uninstalled packages" off
paccache -ruk0

header "optimizing package DB" off
pacman-optimize
