#!/bin/sh

dotfiles_app="$(cd -- "$(dirname -- "$0")" > /dev/null && pwd)"

local_packages="$HOME/Library/Application Support/Sublime Text/Packages"

mkdir -p "$local_packages"
if [ ! -d "$local_packages" ]; then
    echo >&2 "$(basename "$0"): failed to provide app's local packages directory for symlinks"
    exit 1
fi

for filename in "User" "User Markdown"; do
    echo "$(tput setaf 3)Symlinking $filename$(tput sgr0)"
    ln -s "$dotfiles_app/Packages/$filename" "$local_packages"

    if [ "$?" -ne 0 ]; then
        echo "$(tput setaf 1)Symlinking $filename has failed$(tput sgr0)"
    fi
done
