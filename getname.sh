#!/bin/bash

if [[ " $@ " == *" -h "* ]]; then
  grep -A 1 --colour "\#\+\s*$(basename $0)" $(dirname $0)/README.md
  exit 0
fi

cap=$(basename $(pwd))
echo -n $cap | xclip -sel clip
echo $cap
