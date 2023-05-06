#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/exit.sh"
source "$mixins/require.sh"


assert_loaded_environment
require_macos
require_macos_application "Telegram"


defaults write ru.keepcoder.Telegram kArchiveIsHidden -bool true  # Hide archived chats from All Chats

killall "Telegram" &> /dev/null
exit_with_success
