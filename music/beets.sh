#!/bin/bash

. `dirname "$0"`/includes.sh

echo "beet list source::^$"
echo

today="`date +%Y-%m-%d`"
echo "----- today"
echo "beet modify added:\"${today}\"" source=$1
echo "beet modify added:\"${today}\"" source=$1 manual=1
echo "beet modify added:\"${today}\"" source=$1 new=1
echo "beet modify added:\"${today}\"" source=$1 new=1 manual=1
echo "beet modify added:\"${today}\"" source=$1 format:flac
echo "beet modify added:\"${today}\"" source=$1 format:ogg
echo "beet modify added:\"${today}\"" source=$1 format:mp3
echo "beet modify added:\"${today}\"" source=$1 artist:$2
echo
echo "----- write & move"
echo "beet write added:\"${today}\"; beet move added:\"${today}\""
echo
