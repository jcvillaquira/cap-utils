#!/bin/bash

if [[ " $@ " == *" -h "* ]]; then
  grep -A 1 --colour "\#\+\s*$(basename $0)" $(dirname $0)/README.md
  exit 0
fi

declare -A program=(
  [csv]="libreoffice --norestore"
  [pdf]=evince
  [px]=nvim
  [txt]=nvim
  [html]=firefox
  [xls]="libreoffice --norestore"
  [xlsx]="libreoffice --norestore"
)

declare -A params
if [[ -n $@ ]]; then
  params[f]=file,table
else
  params[f]="*"
fi

modified_prefix=0
while getopts "n:f:e:p:h" flag; do
  if [[ $flag == f ]]; then
    modified_prefix=1
  fi
  params[$flag]=$OPTARG
done

if [[ $modified_prefix -eq 0 && -n $@ ]]; then
  fullname=($(eval ls downloads/*/downloads/*/{${params[f]}}${params[n]}.* 2> /dev/null))
else
  fullname=($(ls downloads/*/downloads/*/${params[f]}${params[n]}.* 2> /dev/null))
fi

if [[ ! -n $fullname ]]; then
  echo "File downloads/*/downloads/*/{${params[f]}}${params[n]}.* not found."
  exit 1
fi
echo $fullname > $(dirname $0)/temp

echo "Opening $fullname"
filename=$(basename $fullname)
extension=${filename##*.}

if [[ -v params[p] ]]; then
  program[$extension]=${params[p]}
fi

if [[ ! -v program[$extension] ]]; then
  echo "Extension '$extension' not recognized, please add it to $0 or specify program with the flag -p."
  exit 1
fi

${program[$extension]} $fullname
