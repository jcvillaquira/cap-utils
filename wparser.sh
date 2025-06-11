#!/bin/bash

show_help() {
  grep -A 1 --colour "\#\+\s*$(basename $0)" $(dirname $0)/README.md
}

if [[ " $@ " == *" -h "* ]]; then
  show_help
  exit 0
fi

parser_path=$(ls parsers/*/parser.py 2> /dev/null)
if [[ ! -f $parser_path ]]; then
  show_help
  exit 1
fi
parser_hash=

grep_pattern=(--colour=auto -P -e '((Launching|Starting\sparser|Finished|Saved|Found).*)|^')
while getopts "g:" flag; do
  case $flag in
    g) grep_pattern=(--colour=auto $OPTARG);;
  esac
done

while true; do
  if [[ "$parser_hash" == "$(cat $parser_path | shasum)" ]]; then
    sleep 0.2
    continue
  fi
  clear
  parser_hash="$(cat $parser_path | shasum)" 
  cap run -p | grep "${grep_pattern[@]}"
done

