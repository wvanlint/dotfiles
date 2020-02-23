base=$(realpath $(dirname $0))/home_files
echo "Linking relative from $base"
cd $base

for file in $(find . -type f); do
  home_file=$(realpath -s $HOME/$file)
  base_file=$(realpath -s $base/$file)
  mkdir -p $(dirname $home_file)
  echo "Linking $home_file to $base_file"
  ln -s -f $base_file $home_file
done
