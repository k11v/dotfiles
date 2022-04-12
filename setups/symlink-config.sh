#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$(basename "$0"): dotfiles 'config' directory was not provided"
    exit 1
fi

dotfiles_config="$1"

if [ "$(printf '%s' "$dotfiles_config" | cut -c1)" != "/" ]; then
    echo >&2 "$(basename "$0"): dotfiles 'config' directory must be provided via an absolute path"
    exit 1
fi

if [ ! -d "$dotfiles_config" ]; then
    echo >&2 "$(basename "$0"): provided dotfiles 'config' directory is not a directory"
    exit 1
fi

local_config="$HOME/.config"

mkdir -p "$local_config"
if [ ! -d "$local_config" ]; then
    echo >&2 "$(basename "$0"): failed to provide local config directory for symlinks"
    exit 1
fi

for cfg in "$dotfiles_config/"*; do
    filename="$(basename "$cfg")"
    echo "$(tput setaf 3)Symlinking $filename$(tput sgr0)"
    ln -s "$dotfiles_config/$filename" "$local_config"

    if [ "$?" -ne 0 ]; then
        echo "$(tput setaf 1)Symlinking $filename has failed$(tput sgr0)"
    fi
done
