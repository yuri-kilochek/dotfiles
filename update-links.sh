#!/usr/bin/sh

dir=$(dirname "$0")
file=$(basename "$0")
for f in $(find $dir -type f -and -not -path "$dir/.git/**" -and -not -name $file); do
    f=${f#$(echo $dir/)}
    ln -f $f ~/$f
done

