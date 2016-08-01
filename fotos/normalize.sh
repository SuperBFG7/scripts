#!/bin/bash

. `dirname "$0"`/includes.sh

args="imgdir"

# check arguments
check_arg "$1" "$args" "no image directory specified"

SIZE="800x800"

# basic assignments
DIR="$1"

# normalize filenames
rename DSC dsc "$DIR/"*
rename IMG img "$DIR/"*
rename CR2 cr2 "$DIR/"*
rename JPG jpg "$DIR/"*

# autorotate images based on EXIF orientation flag
jhead -autorot "$DIR/"*.jpg

