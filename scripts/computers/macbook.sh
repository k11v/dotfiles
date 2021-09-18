#!/bin/sh

# Ask for the administrator password upfront
sudo -v

# Set computer name
scutil --set ComputerName "Cyril's MacBook"
scutil --set LocalHostName 'cyrils-macbook'
