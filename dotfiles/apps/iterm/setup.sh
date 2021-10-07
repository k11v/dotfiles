#!/bin/sh

dotfiles_app_dir="$(cd -- "$(dirname -- "$0")" > /dev/null && pwd)"

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$dotfiles_app_dir"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

killall "iTerm2" &> /dev/null
