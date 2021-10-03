#!/bin/sh

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing 'sudo' time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &


#
# Preferences
#


# Set computer name
scutil --set ComputerName "Cyril's MacBook"
scutil --set LocalHostName "cyrils-macbook"

# macOS Mojave: stop iTunes from opening when an iPhone is connected
defaults read com.apple.iTunes dontAutomaticallySyncIPods -bool true


#
# Cleanup
#


# Kill affected applications
for app in "iTunes"; do
    killall "$app" &> /dev/null
done
