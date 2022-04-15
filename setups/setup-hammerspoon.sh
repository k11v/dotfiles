#!/bin/sh

if [ "$DOTFILES_ENVIRONMENT_LOADED" -ne 1 ]; then
    echo >&2 "$(basename "$0"): Environment doesn't seem to be loaded"
    exit 1
fi
if [ -z "$DOTFILES_SETUP_MIXINS" ]; then
    echo >&2 "$(basename "$0"): DOTFILES_SETUP_MIXINS wasn't passed to the setup"
    exit 1
fi
source "$DOTFILES_SETUP_MIXINS/require.sh"
source "$DOTFILES_SETUP_MIXINS/exit.sh"


require_macos
require_macos_application "Hammerspoon"


defaults write org.hammerspoon.Hammerspoon MJShowDockIconKey -bool true   # Unhide Dock icon
defaults write org.hammerspoon.Hammerspoon MJShowMenuIconKey -bool false  # Hide menu bar icon

killall "Hammerspoon" &> /dev/null
exit_with_success
