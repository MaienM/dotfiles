#!/usr/bin/env sh

mkdir -p "$HOME/.cache/vim/"{backup,swap,undo}

find . -type f -name '*~' ! -name '.*.un~' -print0 | while IFS= read -d '' -r file; do
    echo mv "$file" "$HOME/.cache/vim/backup/$(realpath "$file" | sed 's!/\(.*\)~$!/\1!; s!/!%!g')"
done
find . -type f -name '.*.sw[op]' -print0 | while IFS= read -d '' -r file; do
    echo mv "$file" "$HOME/.cache/vim/swap/$(realpath "$file" | sed 's!/\.\(.*\.sw[op]\)$!/\1!; s!/!%!g')"
done
find . -type f -name '.*.un~' -print0 | while IFS= read -d '' -r file; do
    echo mv "$file" "$HOME/.cache/vim/undo/$(realpath "$file" | sed 's!/\.\(.*\)\.un~$!/\1!; s!/!%!g')"
done
