#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$(basename "$0"): dotfiles 'home' directory was not provided"
    exit 1
fi

dotfiles_home="$1"

if [ "$(printf '%s' "$dotfiles_home" | cut -c1)" != "/" ]; then
    echo >&2 "$(basename "$0"): dotfiles 'home' directory must be provided via an absolute path"
    exit 1
fi

if [ ! -d "$dotfiles_home" ]; then
    echo >&2 "$(basename "$0"): provided dotfiles 'home' directory is not a directory"
    exit 1
fi

local_home="$HOME"

mkdir -p "$local_home"
if [ ! -d "$local_home" ]; then
    echo >&2 "$(basename "$0"): failed to provide local home directory for symlinks"
    exit 1
fi

for file in "$dotfiles_home/".*; do
    filename="$(basename "$file")"

    [ "$filename" = ".DS_Store" ] && continue
    [ "$filename" = "." ] && continue
    [ "$filename" = ".." ] && continue

    echo "$(tput setaf 3)Symlinking $filename$(tput sgr0)"
    ln -s "$dotfiles_home/$filename" "$local_home"

    if [ "$?" -ne 0 ]; then
        echo "$(tput setaf 1)Symlinking $filename has failed$(tput sgr0)"
    fi
done
