#!/bin/sh

dotfiles_app="$(cd -- "$(dirname -- "$0")" > /dev/null && pwd)"

local_app_config="$HOME/.config/karabiner"

mkdir -p "$local_app_config"
if [ ! -d "$local_app_config" ]; then
    echo >&2 "$(basename "$0"): failed to provide app's local config directory for symlinks"
    exit 1
fi

for filename in "assets" "karabiner.json"; do
    echo "$(tput setaf 3)Symlinking $filename$(tput sgr0)"
    ln -s "$dotfiles_app/$filename" "$local_app_config"

    if [ "$?" -ne 0 ]; then
        echo "$(tput setaf 1)Symlinking $filename has failed$(tput sgr0)"
    fi
done
