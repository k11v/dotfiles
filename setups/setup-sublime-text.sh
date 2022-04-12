#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$(basename "$0"): 'sublime-text.dotfiles' directory was not provided"
    exit 1
fi

dotfiles_sublime_dir="$1"

if [ "$(printf '%s' "$dotfiles_sublime_dir" | cut -c1)" != "/" ]; then
    echo >&2 "$(basename "$0"): 'sublime-text.dotfiles' directory must be provided via an absolute path"
    exit 1
fi

if [ ! -d "$dotfiles_sublime_dir" ]; then
    echo >&2 "$(basename "$0"): provided 'sublime-text.dotfiles' directory is not a directory"
    exit 1
fi


local_sublime_packages_dir="$HOME/Library/Application Support/Sublime Text/Packages"

mkdir -p "$local_sublime_packages_dir"
if [ ! -d "$local_sublime_packages_dir" ]; then
    echo >&2 "$(basename "$0"): failed to provide Sublime Text's local packages directory for symlinks"
    exit 1
fi

for package in "$dotfiles_sublime_dir/Packages/"*; do
    filename="$(basename "$package")"
    echo "$(tput setaf 3)Symlinking $filename$(tput sgr0)"
    ln -s "$dotfiles_sublime_dir/Packages/$filename" "$local_sublime_packages_dir"

    if [ "$?" -ne 0 ]; then
        echo "$(tput setaf 1)Symlinking $filename has failed$(tput sgr0)"
    fi
done
