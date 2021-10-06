#!/bin/sh

dotfiles_app="$(cd -- "$(dirname -- "$0")" > /dev/null && pwd)"

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$dotfiles_app"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

killall "iTerm2" &> /dev/null
