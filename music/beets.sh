#!/bin/bash

. `dirname "$0"`/includes.sh

echo "beet list source::^$"
echo

echo "----- today"
echo "beet modify added:-1d.. source=$1"
echo "beet modify added:-1d.. source=$1 manual=1"
echo "beet modify added:-1d.. source=$1 new=1"
echo "beet modify added:-1d.. source=$1 new=1 manual=1"
echo "beet modify added:-1d.. source=$1 format:flac"
echo "beet modify added:-1d.. source=$1 format:ogg"
echo "beet modify added:-1d.. source=$1 format:mp3"
echo "beet modify added:-1d.. source=$1 artist:$2"
echo
echo "----- write & move"
echo "beet write added:-1d..; beet move added:-1d.."
echo
