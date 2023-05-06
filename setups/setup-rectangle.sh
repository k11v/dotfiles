#!/bin/sh

if [ -z "$DOTFILES_SETUP_MIXINS" ]; then
    echo >&2 "$(basename "$0"): DOTFILES_SETUP_MIXINS wasn't passed to the setup"
    exit 1
fi
source "$DOTFILES_SETUP_MIXINS/require.sh"
source "$DOTFILES_SETUP_MIXINS/exit.sh"


require_environment
require_macos
require_macos_application "Rectangle"


defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -int 1  # Set shortcuts to Rectangle defaults
defaults write com.knollsoft.Rectangle launchOnLogin -bool false         # Don't launch Rectangle on login
defaults write com.knollsoft.Rectangle hideMenubarIcon -bool true        # Hide menu bar icon
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 2    # Do nothing
defaults write com.knollsoft.Rectangle windowSnapping -int 2             # Turn off window snapping

killall "Rectangle" &> /dev/null
exit_with_success
