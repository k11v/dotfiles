#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$0: 'bins' directory was not provided"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo >&2 "$0: provided 'bins' directory is not a directory"
    exit 1
fi

dotfiles_bins="$1"
local_bins="$HOME/.local/bin"

mkdir -p "$local_bins"

for bin in "$dotfiles_bins/"*; do
    filename="$(basename "$bin")"
    echo "Symlinking $filename"
    ln -s "$dotfiles_bins/$filename" "$local_bins/$filename"
done
