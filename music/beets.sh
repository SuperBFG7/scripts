#!/bin/bash

. `dirname "$0"`/includes.sh

echo "beet import ."
echo "beet list source::^$"
echo

echo "----- library"
echo "mkdir /data/music/lossless/flac.beets/$1"
echo "ln -s ../../lossless/flac.beets/$1 ."
echo "clear"
echo "ls -l"
echo "$0 $1"
echo "beet modify source=$1 source::^$"
echo "beet move source:$1"
echo

today="`date +%Y-%m-%d`"
echo "----- today"
echo "beet modify new=1 source=$1 added:\"${today}\""
echo "beet modify new=1 manual=1 source=$1 added:\"${today}\""
echo "beet modify manual=1 source=$1 added:\"${today}\""
echo "beet modify source=$1 added:\"${today}\""
echo "beet modify source=$1 added:\"${today}\"" format:flac
echo "beet modify source=$1 added:\"${today}\"" format:ogg
echo "beet modify source=$1 added:\"${today}\"" format:mp3
echo "beet modify source=$1 added:\"${today}\"" artist:$2
echo
echo "----- write & move"
echo "beet write added:\"${today}\"; beet move added:\"${today}\""
echo
