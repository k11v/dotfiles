#! /bin/zsh

killall iTerm2

# specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$0:A:h"
# tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
