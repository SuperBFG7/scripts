#!/bin/bash

dict=/usr/share/dict/british-english
lower=2
upper=2

. `dirname "$0"`/includes.sh

length=$(($lower + $upper))

(shuf -n $lower $dict | tr "[:upper:]" "[:lower:]";
 shuf -n $upper $dict | tr "[:lower:]" "[:upper:]") | 
 shuf -n $length  | tr -cd "A-Za-z\n" | tr "\n" "-";
 echo $(shuf -i0-999 -n 1)
