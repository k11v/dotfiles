#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$(basename "$0"): 'iterm2.dotfiles' directory was not provided"
    exit 1
fi

dotfiles_iterm2_dir="$1"

if [ "$(printf '%s' "$dotfiles_iterm2_dir" | cut -c1)" != "/" ]; then
    echo >&2 "$(basename "$0"): 'iterm2.dotfiles' directory must be provided via an absolute path"
    exit 1
fi

if [ ! -d "$dotfiles_iterm2_dir" ]; then
    echo >&2 "$(basename "$0"): provided 'iterm2.dotfiles' directory is not a directory"
    exit 1
fi

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$dotfiles_iterm2_dir"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

killall "iTerm2" &> /dev/null
