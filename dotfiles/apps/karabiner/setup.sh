#!/bin/sh

dotfiles_app_dir="$(cd -- "$(dirname -- "$0")" > /dev/null && pwd)"

local_config_dir="$HOME/.config"

mkdir -p "$local_config_dir"
if [ ! -d "$local_config_dir" ]; then
    echo >&2 "$(basename "$0"): failed to provide config directory for symlinks"
    exit 1
fi

for filename in "karabiner"; do
    echo "$(tput setaf 3)Symlinking $filename$(tput sgr0)"
    ln -s "$dotfiles_app_dir/$filename" "$local_config_dir"

    if [ "$?" -ne 0 ]; then
        echo "$(tput setaf 1)Symlinking $filename has failed$(tput sgr0)"
    fi
done
