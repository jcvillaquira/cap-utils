#!/bin/bash

show_help() {
  echo "Usage: $0 [-c | -u] [-n N]"
  echo
  echo "  -c         Comment all @parser.source classes (and their bodies)"
  # echo "  -u         Uncomment all previously commented @parser.source classes" # TODO: Solve how to uncomment!
  echo "  -n N       Skip the first N decorated classes (e.g., -n 1 skips the first match)"
  echo "  -h         Show this help message"
  exit 0
}

action=""
skip_first=0

# while getopts "cun:h" opt; do
while getopts "cn:h" opt; do
  case $opt in
  c) action="comment" ;;
  # u) action="uncomment" ;;
  n) skip_first=$OPTARG ;;
  h) show_help ;;
  *) show_help ;;
  esac
done

if [[ -z "$action" ]]; then
  # echo "You must specify -c (comment) or -u (uncomment)."
  echo "You must specify -c (comment)"
  show_help
fi

file=$(find . -type f -name "parser.py" | head -n 1)
[[ ! -f "$file" ]] && echo "No parser.py found." && exit 1

echo "Processing $file ($action)..."

tmp_file=$(mktemp)
in_block=0
expecting_class=0
block_indent=""
class_indent=""
decorated_class_index=0

while IFS= read -r line || [[ -n "$line" ]]; do
  # Detect @parser.source
  if [[ "$line" =~ ^([[:space:]]*)@parser\.source ]]; then
    ((decorated_class_index++))
    block_indent="${BASH_REMATCH[1]}"

    if [[ $decorated_class_index -le $skip_first ]]; then
      echo " → Skipping decorated class #$decorated_class_index"
      in_block=0
      expecting_class=0
      echo "$line" >>"$tmp_file"
      continue
    fi

    echo " + Found @parser.source (match #$decorated_class_index)"
    in_block=1
    expecting_class=1
    [[ "$action" == "comment" ]] && echo "# $line" >>"$tmp_file" || echo "${line#\# }" >>"$tmp_file"
    continue
  fi

  # Expecting class line
  if [[ $expecting_class -eq 1 && "$line" =~ ^([[:space:]]*)class[[:space:]]+([A-Za-z_][A-Za-z0-9_]*) ]]; then
    class_indent="${BASH_REMATCH[1]}"
    class_name="${BASH_REMATCH[2]}"
    echo "   ** $action -> class $class_name"
    expecting_class=0
    [[ "$action" == "comment" ]] && echo "# $line" >>"$tmp_file" || echo "${line#\# }" >>"$tmp_file"
    continue
  fi

  # Inside class body
  if [[ $in_block -eq 1 ]]; then
    if [[ -z "$line" ]]; then
      [[ "$action" == "comment" ]] && echo "# $line" >>"$tmp_file" || echo "${line#\# }" >>"$tmp_file"
      continue
    fi

    if [[ "$line" =~ ^$class_indent[[:space:]]+ ]]; then
      [[ "$action" == "comment" ]] && echo "# $line" >>"$tmp_file" || echo "${line#\# }" >>"$tmp_file"
    else
      # Exit class block
      in_block=0
      echo "$line" >>"$tmp_file"
    fi
    continue
  fi

  # Outside any block
  echo "$line" >>"$tmp_file"
done <"$file"

cp "$file" "$file.bak"
mv "$tmp_file" "$file"

echo "Done. Modified $file"
