#!/bin/bash

if [[ " $@ " == *" -h "* ]]; then
  grep -A 1 --colour "\#\+\s*$(basename $0)" $(dirname $0)/README.md
  exit 0
fi

declare -a index=($(ls downloads/*/index.txt* 2> /dev/null))
for fl in ${index[@]}; do
  if [[ $fl != *.lock ]]; then
    echo "Deleting $fl" | grep --color 'Deleting.*'
    cat $fl
    echo
  fi
  rm $fl
done
