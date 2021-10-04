#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$(basename "$0"): 'cfgs' directory was not provided"
    exit 1
fi

dotfiles_cfgs="$1"

if [ "$(printf '%s' "$dotfiles_cfgs" | cut -c1)" != "/" ]; then
    echo >&2 "$(basename "$0"): 'cfgs' directory must be provided via an absolute path"
    exit 1
fi

if [ ! -d "$dotfiles_cfgs" ]; then
    echo >&2 "$(basename "$0"): provided 'cfgs' directory is not a directory"
    exit 1
fi

local_cfgs="$HOME/.config"

mkdir -p "$local_cfgs"
if [ ! -d "$local_cfgs" ]; then
    echo >&2 "$(basename "$0"): failed to provide local config directory for symlinks"
    exit 1
fi

for cfg in "$dotfiles_cfgs/"*; do
    filename="$(basename "$cfg")"
    echo "Symlinking $filename"
    ln -s "$dotfiles_cfgs/$filename" "$local_cfgs"
done
