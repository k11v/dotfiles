#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/assert.sh"
source "$mixins/exit.sh"
source "$mixins/require.sh"


assert_loaded_environment

require_group "macbook"
require_macos


# Give password to sudo upfront and prevent sudo session timeout

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &

# Prevent preferences below from being overridden by System Preferences

osascript -e 'tell application "System Preferences" to quit'

# Set sharing preferences

sudo scutil --set ComputerName "Cyril's MacBook"                       # Set computer name
sudo scutil --set LocalHostName "cyrils-macbook"                       # Set local hostname


exit_with_success
