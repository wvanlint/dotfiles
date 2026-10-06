#!/usr/bin/env bash
set -euo pipefail

if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! hash grealpath 2> /dev/null; then
    echo "coreutils not installed."
    exit 1
  fi
  if ! hash gfind 2> /dev/null; then
    echo "findutils not installed."
    exit 1
  fi
  REALPATH=grealpath
  FIND=gfind
else
  REALPATH=realpath
  FIND=find
fi

base=$("$REALPATH" "$(dirname "$0")")/home_files
target_home=$("$REALPATH" -m "${1:-$HOME}")
echo "Linking relative from $base"
cd "$base"

while IFS= read -r -d '' file; do
  home_file=$("$REALPATH" -m -s "$target_home/$file")
  base_file=$("$REALPATH" -m -s "$base/$file")
  mkdir -p "$(dirname "$home_file")"
  link_target=$("$REALPATH" -m -s --relative-to="$(dirname "$home_file")" "$base_file")
  echo "Linking $home_file to $link_target"
  ln -s -f "$link_target" "$home_file"
done < <("$FIND" . -type f -print0)
