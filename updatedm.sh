#!/bin/bash

if [[ " $@ " == *" -h "* ]]; then
  grep -A 1 --colour "\#\+\s*$(basename $0)" $(dirname $0)/README.md
  exit 0
fi

capname=$(mktemp)
$(dirname $0)/getname.sh > $capname

cd /tmp
cap download $(< $capname)

declare -a new_options=($(ls /tmp/$(< $capname)/downloads/*/options.json 2> /dev/null))

if [[ ! -f $new_options ]]; then
  echo "New options file could not be found for automation '$(< $capname)'" | grep --colour $(< $capname)
  exit 1
fi

cd - > /dev/null

for fl in $(ls downloads/*/options.json 2> /dev/null); do
  cp $new_options $fl
done
rm -rf /tmp/$(< $capname)
rm $capname
