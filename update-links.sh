#!/usr/bin/sh

dir=$(dirname "$0")
file=$(basename "$0")
for f in $(find "$dir" -type f -and -not -path "$dir/.git/**" -and -not -name "$file"); do
    f=${f#"$dir/"}
    d="$(dirname "$f")"
    mkdir -p ~/"$d"
    ln -f "$f" ~/"$f"
done

