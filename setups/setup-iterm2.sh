#!/bin/sh

if [ -z "$DOTFILES_SETUP_MIXINS" ]; then
    echo >&2 "$(basename "$0"): DOTFILES_SETUP_MIXINS wasn't passed to the setup"
    exit 1
fi
source "$DOTFILES_SETUP_MIXINS/assert.sh"
source "$DOTFILES_SETUP_MIXINS/exit.sh"
source "$DOTFILES_SETUP_MIXINS/require.sh"


require_environment
require_macos
require_macos_application "iTerm"


assert_non_empty_string "$1" "First argument (dotfiles-iterm2-directory) is missing"
assert_absolute_path "$1"
assert_directory "$1"


defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$1"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

exit_with_success
