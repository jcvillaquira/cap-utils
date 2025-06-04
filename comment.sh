#!/bin/bash

if [[ " $@ " == *" -h "* ]]; then
  echo "Usage: $0 [-c | -u]"
  echo "Comments or uncomments all nch.js files under downloads/, except the first one found."
  exit 0
fi

action="comment"
if [[ " $@ " == *"-u"* ]]; then
  action="uncomment"
fi

files=($(find downloads/ -type f -name "nch.js" | sort))

if [[ ${#files[@]} -le 1 ]]; then
  echo "No multiple nch.js files found to process."
  exit 0
fi

files_to_process=("${files[@]:1}")

echo "Processing ${#files_to_process[@]} file(s) ($action)..."

for file in "${files_to_process[@]}"; do
  echo "→ $file"

  if [[ "$action" == "comment" ]]; then
    sed -i 's|^|//|' "$file"
  elif [[ "$action" == "uncomment" ]]; then
    sed -i 's|^//||' "$file"
  fi
done

echo "Done."
