#!/bin/sh

# Ask for the administrator password upfront
sudo -v

# Set computer name
scutil --set ComputerName "Cyril's MacBook"
scutil --set LocalHostName 'cyrils-macbook'

# macOS Mojave: stop iTunes from opening when an iPhone is connected
defaults read com.apple.iTunes dontAutomaticallySyncIPods -bool true
