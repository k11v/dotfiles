#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$(basename "$0"): 'cfgs' directory was not provided"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo >&2 "$(basename "$0"): provided 'cfgs' directory is not a directory"
    exit 1
fi

dotfiles_cfgs="$1"
local_cfgs="$HOME/.config"

mkdir -p "$local_cfgs"

for cfg in "$dotfiles_cfgs/"*; do
    filename="$(basename "$cfg")"
    echo "Symlinking $filename"
    ln -s "$dotfiles_cfgs/$filename" "$local_cfgs"
done
