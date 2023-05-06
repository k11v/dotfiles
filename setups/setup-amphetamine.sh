#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/assert.sh"
source "$mixins/exit.sh"
source "$mixins/require.sh"


assert_loaded_environment

require_macos
require_macos_application "Amphetamine"


defaults write com.if.Amphetamine "Show Welcome Window" -bool false         # Don't show welcome window
defaults write com.if.Amphetamine "Enable Session State Sound" -bool false  # Don't play sound when any session starts or ends
defaults write com.if.Amphetamine "Icon Style" -int 5                       # Set menu bar icon to a coffee cup

killall "Amphetamine" &> /dev/null
exit_with_success
