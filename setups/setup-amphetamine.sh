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
require_macos_application "Amphetamine"


defaults write com.if.Amphetamine "Show Welcome Window" -bool false         # Don't show welcome window
defaults write com.if.Amphetamine "Enable Session State Sound" -bool false  # Don't play sound when any session starts or ends
defaults write com.if.Amphetamine "Icon Style" -int 5                       # Set menu bar icon to a coffee cup

killall "Amphetamine" &> /dev/null
exit_with_success
