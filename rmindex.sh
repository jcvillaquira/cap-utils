#!/bin/bash

declare -a index=($(ls downloads/*/index.txt* 2> /dev/null))
for fl in ${index[@]}; do
  if [[ $fl != *.lock ]]; then
    echo "Deleting $fl" | grep --color 'Deleting.*'
    cat $fl
    echo
  fi
  rm $fl
done
