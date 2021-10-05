#!/bin/sh

# Give password to sudo upfront and prevent sudo session timeout

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &

# Prevent preferences below from being overridden by System Preferences

osascript -e 'tell application "System Preferences" to quit'

# Set sharing preferences

sudo scutil --set ComputerName "Cyril's MacBook"                       # Set computer name
sudo scutil --set LocalHostName "cyrils-macbook"                       # Set local hostname

# Set iTunes preferences (macOS Mojave)

defaults write com.apple.iTunes dontAutomaticallySyncIPods -bool true  # Don't automatically open iTunes when devices are plugged in

# Kill affected programs

for program in "iTunes"; do
    killall "$program" &> /dev/null
done
