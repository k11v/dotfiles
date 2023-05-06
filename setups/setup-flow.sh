#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/exit.sh"
source "$mixins/require.sh"


assert_loaded_environment
require_macos
require_macos_application "Flow"


defaults write design.yugen.Flow showWelcomeWindow -bool false  # Don't show welcome window

killall "Flow" &> /dev/null
exit_with_success
