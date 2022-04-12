#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$(basename "$0"): dotfiles 'bin' directory was not provided"
    exit 1
fi

dotfiles_bin="$1"

if [ "$(printf '%s' "$dotfiles_bin" | cut -c1)" != "/" ]; then
    echo >&2 "$(basename "$0"): dotfiles 'bin' directory must be provided via an absolute path"
    exit 1
fi

if [ ! -d "$dotfiles_bin" ]; then
    echo >&2 "$(basename "$0"): provided dotfiles 'bin' directory is not a directory"
    exit 1
fi

local_bin="$HOME/.local/bin"

mkdir -p "$local_bin"
if [ ! -d "$local_bin" ]; then
    echo >&2 "$(basename "$0"): failed to provide local bin directory for symlinks"
    exit 1
fi

for bin in "$dotfiles_bin/"*; do
    filename="$(basename "$bin")"
    echo "$(tput setaf 3)Symlinking $filename$(tput sgr0)"
    ln -s "$dotfiles_bin/$filename" "$local_bin"

    if [ "$?" -ne 0 ]; then
        echo "$(tput setaf 1)Symlinking $filename has failed$(tput sgr0)"
    fi
done
