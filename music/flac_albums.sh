#!/bin/bash

beet ls -f '$albumartist // $album' format:flac | sed -e "s/The //" | sort -fd | uniq
