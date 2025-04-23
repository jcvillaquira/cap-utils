#!/bin/bash

echo $fullname > $(dirname $0)/temp

declare -A program=(
  [csv]="libreoffice --norestore"
  [pdf]=evince
  [px]=nvim
  [txt]=nvim
  [xls]="libreoffice --norestore"
  [xlsx]="libreoffice --norestore"
)

declare -A params=([f]=file)
while getopts "n:f:e:p:h" flag; do
  if [[ $flag == h ]]; then
    grep -A 1 --colour "\#\+\s*$(basename $0)" $(dirname $0)/README.md
    exit 0
  fi
  params[$flag]=$OPTARG
done

basename=${params[f]}${params[n]}
tmp_err=$(mktemp)
fullname=$(ls downloads/*/downloads/*/$basename.* 2> $tmp_err)
if [[ -n $(<$tmp_err) ]]; then
  echo "File downloads/*/downloads/*/$basename.* not found."
  exit 1
fi

echo "Opening $fullname"
filename=$(basename $fullname)
extension=${filename##*.}

if [[ -v params[p] ]]; then
  program[$extension]=${params[p]}
fi

if [[ ! -v program[$extension] ]]; then
  echo "Extension '$extension' not recognized, please add it to the file $0 or specify program with the flag -p."
  exit 1
fi

echo $fullname > $(dirname $0)/temp
${program[$extension]} $fullname
