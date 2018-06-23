#!/bin/bash

. `dirname "$0"`/includes.sh

header "removing unused orphan packages"
pacman -Rns $(/usr/bin/pacman -Qtdq)

header "cleaning package cache: old versions"
paccache -r

header "cleaning package cache: uninstalled packages"
paccache -ruk0

