#!/bin/sh

if [ -z "$DOTFILES_SETUP_MIXINS" ]; then
    echo >&2 "$(basename "$0"): DOTFILES_SETUP_MIXINS wasn't passed to the setup"
    exit 1
fi
source "$DOTFILES_SETUP_MIXINS/require.sh"
source "$DOTFILES_SETUP_MIXINS/exit.sh"


require_environment
require_macos
require_macos_application "Telegram"


defaults write ru.keepcoder.Telegram kArchiveIsHidden -bool true  # Hide archived chats from All Chats

killall "Telegram" &> /dev/null
exit_with_success
