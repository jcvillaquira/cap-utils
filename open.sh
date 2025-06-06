#!/bin/bash

show_help() {
  grep -A 1 --colour "\#\+\s*$(basename $0)" $(dirname $0)/README.md
}

if [[ " $@ " == *" -h "* ]]; then
  show_help
  exit 0
fi

declare -A program=(
  [csv]="libreoffice --norestore"
  [html]=firefox
  [json]=cat
  [pdf]=evince
  [px]=nvim
  [txt]=nvim
  [xls]="libreoffice --norestore"
  [xlsx]="libreoffice --norestore"
)

declare -A params
params[f]="*"
if [[ " $@ " == *" -n "* ]]; then
  params[f]=file,table
fi

while getopts "n:f:p:c" flag; do
  params[$flag]=$OPTARG
done

if [[ " $@ " != *" -f "* && " $@ " == *" -n "* ]]; then
  fullname=($(eval ls downloads/*/downloads/*/{${params[f]}}${params[n]}.* 2> /dev/null))
else
  fullname=($(ls downloads/*/downloads/*/${params[f]}${params[n]}.* 2> /dev/null))
fi

if [[ ! -n $fullname ]]; then
  echo -e "File \e[3mdownloads/*/downloads/*/{${params[f]}}${params[n]}.*\e[0m not found.\n"
  show_help
  exit 1
fi
echo -e "\e[1;96m$fullname\e[0m"
if [[ " $@ " == *" -c "* ]]; then
  echo $fullname | xclip -sel clip
  exit 0
fi

filename=$(basename $fullname)
extension=${filename##*.}

if [[ -v params[p] ]]; then
  program[$extension]=${params[p]}
fi

if [[ ! -v program[$extension] ]]; then
  echo "Extension '$extension' not recognized, please add it to $0 or specify program with the flag -p."
fi

${program[$extension]:-cat} $fullname
