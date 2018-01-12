#!/bin/bash

beet ls -f '$albumartist // $album' format:flac | sort -fd | uniq
