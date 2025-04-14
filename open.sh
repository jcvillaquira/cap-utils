#!/bin/bash

declare -A program=(
  [csv]=libreoffice
  [pdf]=evince
  [txt]=nvim
  [xls]=libreoffice
  [xlsx]=libreoffice
)

declare -A params=([f]=file [e]=xlsx)
while getopts "n:f:e:p:" flag; do
  params[$flag]=$OPTARG
  if [[ $flag == p ]]; then
    program[${params[e]}]=$OPTARG
  fi
done

if [[ ! -v program[${params[e]}] ]]; then
  echo "Extension '${params[e]}' not found, please add it to the file $0"
  exit 1
fi

filename="${params[f]}${params[n]}"
declare -a fullname=$(ls downloads/*/downloads/*/$filename.${params[e]})

if [[ -f $fullname ]]; then
  ${program[${params[e]}]} $fullname
fi
