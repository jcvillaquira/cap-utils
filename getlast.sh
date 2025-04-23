#!/bin/bash

if [[ " $@ " == *" -h "* ]]; then
  grep -A 1 --colour "\#\+\s*$(basename $0)" $(dirname $0)/README.md
  exit 0
fi

last=$(cat $(dirname $0)/temp 2> /dev/null)
if [[ -f $last ]]; then
  echo -n $last | xclip -sel clip
  echo $last
fi
