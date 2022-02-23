#!/usr/bin/env bash

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

base=$($REALPATH $(dirname $0))/home_files
echo "Linking relative from $base"
cd $base

for file in $($FIND . -type f); do
  home_file=$($REALPATH -m -s $HOME/$file)
  base_file=$($REALPATH -m -s $base/$file)
  mkdir -p $(dirname $home_file)
  $FIND $(dirname $home_file) -maxdepth 1 -xtype l -delete
  mkdir -p $(dirname $home_file)
  echo "Linking $home_file to $base_file"
  ln -s -f $base_file $home_file
done
