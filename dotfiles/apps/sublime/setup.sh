#!/bin/sh

dotfiles_app_dir="$(cd -- "$(dirname -- "$0")" > /dev/null && pwd)"

local_app_packages_dir="$HOME/Library/Application Support/Sublime Text/Packages"

mkdir -p "$local_app_packages_dir"
if [ ! -d "$local_app_packages_dir" ]; then
    echo >&2 "$(basename "$0"): failed to provide app's local packages directory for symlinks"
    exit 1
fi

for package in "$dotfiles_app_dir/Packages/"*; do
    filename="$(basename "$package")"
    echo "$(tput setaf 3)Symlinking $filename$(tput sgr0)"
    ln -s "$dotfiles_app_dir/Packages/$filename" "$local_app_packages_dir"

    if [ "$?" -ne 0 ]; then
        echo "$(tput setaf 1)Symlinking $filename has failed$(tput sgr0)"
    fi
done
