#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$(basename "$0"): 'bins' directory was not provided"
    exit 1
fi

dotfiles_bins="$1"

if [ ! -d "$dotfiles_bins" ]; then
    echo >&2 "$(basename "$0"): provided 'bins' directory is not a directory"
    exit 1
fi

if [ "$(printf '%s' "$dotfiles_bins" | cut -c1)" != "/" ]; then
    echo >&2 "$(basename "$0"): 'bins' directory must be provided via an absolute path"
    exit 1
fi

local_bins="$HOME/.local/bin"

mkdir -p "$local_bins"
if [ ! -d "$local_bins" ]; then
    echo >&2 "$(basename "$0"): failed to provide local bin directory for symlinks"
    exit 1
fi

for bin in "$dotfiles_bins/"*; do
    filename="$(basename "$bin")"
    echo "Symlinking $filename"
    ln -s "$dotfiles_bins/$filename" "$local_bins"
done
