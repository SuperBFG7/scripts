#!/bin/bash

. "$(dirname "$0")/includes.sh"

dict=/usr/share/dict/british-english
lower=2
upper=2
length=$((lower + upper))

(shuf -n "$lower" "$dict" | tr "[:upper:]" "[:lower:]";
 shuf -n "$upper" "$dict" | tr "[:lower:]" "[:upper:]") | 
 shuf -n "$length"  | tr -cd "A-Za-z\n" | tr "\n" "-";
shuf -i0-999 -n 1
